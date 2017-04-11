class Blueprint < Structure::Base
  class Inspection
    def initialize(blueprint, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Blueprint (#{blueprint.structure_class})", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 20, "Needs #{blueprint.needs}", 16, "fonts/arial.ttf")
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :needs, :structure_class, :x, :y

  def initialize(structure_class, x, y)
    @structure_class = structure_class
    @size            = structure_class.size
    @x, @y = x, y

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "blue")
    @mask.color.opacity = 0.4

    @needs = []
    @jobs  = []

    structure_class.structure_requirements.each do |requirement|
      @needs << requirement
      @jobs << SupplyJob.new(requirement, to: self)
    end
  end

  def size
    @structure_class.size
  end

  def has_job?(type)
    @jobs.any?{|j| j.type == type and j.available? }
  end

  def get_job(type)
    job = @jobs.find{|j| j.type == type and j.available? }
    @jobs.delete(job)
  end

  def remove
    @mask.remove
  end

  def supply(item)
    if @needs.include?(item.type)
      @needs.delete(item.type)
      if @needs.empty?
        self.remove
        $structures.delete(self)
        $structures << Construction.new(@structure_class, @x, @y)
      end
    else
      require "pry"
      binding.pry
      raise ArgumentError, "Incorrect item brought"
    end
  end

  def update(seconds)
  end
end

class Construction < Structure::Base
  class Inspection
    def initialize(construction, opts = {})
      x = opts[:x]
      y = opts[:y]
      @text = Text.new(x, y, "Construction (#{construction.structure_class})", 16, "fonts/arial.ttf")
    end

    def remove
      @text.remove
    end
  end

  attr_reader :structure_class, :x, :y

  def initialize(structure_class, x, y)
    @structure_class = structure_class
    @size            = structure_class.size
    @x, @y = x, y

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "gray")
    @mask.color.opacity = 0.8

    @jobs  = [BuildJob.new(structure: self)]
  end

  def size
    @structure_class.size
  end

  def building_time
    @structure_class.building_time
  end

  def remove
    @mask.remove
  end

  def finished_building!
    self.remove
    $structures.delete(self)
    $structures << @structure_class.new(@x, @y)
  end

  def has_job?(type)
    @jobs.any?{|j| j.type == type and j.available? }
  end

  def get_job(type)
    job = @jobs.find{|j| j.type == type and j.available? }
    @jobs.delete(job)
  end

  def update(seconds)
  end
end


class Workshop < Structure::Base
  class Inspection
    def initialize(workshop, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Workshop", 16, "fonts/arial.ttf")

      count = workshop.jobs.count{|j| j.is_a? ProduceJob }

      msg = "Request tables: #{count}"
      @texts << Text.new(x, y + 20, msg, 16, "fonts/arial.ttf")
      # @texts << Text.new(x, y + 40, "Press k to decrease", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 60, "Press l to increase", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 80, "Supplies:", 16, "fonts/arial.ttf")

      logs_count = workshop.supplies.count{|thing| thing.is_a? Log }

      @texts << Text.new(x, y + 100, "Logs: #{logs_count}", 16, "fonts/arial.ttf")
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :size, :stage
  attr_reader :jobs, :supplies

  def self.structure_requirements
    [:log]
  end

  def self.building_time
    20.minutes
  end

  def self.size
    3
  end

  def initialize(x, y)
    @x, @y = x, y
    @size  = self.class.size

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "green")
    @mask.color.opacity = 0.6

    @jobs     = []
    @supplies = []
  end

  def passable?
    true
  end

  def has_stuff_required_for(item_type)
    if item_type == :table
      @supplies.any?{|s| s.type == :log }
    end
  end

  def request_table
    @jobs << SupplyJob.new(:log, to: self)
    @jobs << ProduceJob.new(:table, at: self)
  end

  def produce(item_type)
    if item_type == :table
      log = @supplies.find{|el| el.is_a? Log}
      @supplies.delete(log)
      spot = $map.find_free_spot_near(self)
      item = Table.new(spot.x, spot.y)
      $map[spot.x, spot.y] = item
      item
    end
  end

  def supply(item)
    @supplies << item
  end

  def has_job?(type)
    @jobs.any?{|j| j.type == type and j.available? }
  end

  def get_job(type)
    job = @jobs.find{|j| j.type == type and j.available? }
    @jobs.delete(job)
  end

  def update(time)
  end
end
