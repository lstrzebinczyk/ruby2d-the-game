class Workshop < Structure::Base
  class Inspection
    def initialize(workshop, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      if workshop.stage == :blueprint
        @texts << Text.new(x, y, "Workshop (blueprint)", 16, "fonts/arial.ttf")
        @texts << Text.new(x, y + 20, "Needs 1 log", 16, "fonts/arial.ttf")
      elsif workshop.stage == :building
        @texts << Text.new(x, y, "Workshop (building)", 16, "fonts/arial.ttf")
      else
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
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :size, :stage
  attr_reader :jobs, :supplies

  def initialize(x, y)
    @x, @y = x, y
    @size  = 3

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "blue")
    @mask.color.opacity = 0.4

    @stage = :blueprint
    @needs = [:log]
    @jobs     = []
    @supplies = []

    supply_job = SupplyJob.new(:log, to: self)
    $job_list.add(supply_job)
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

    # require "pry"
    # binding.pry


    @jobs << SupplyJob.new(:log, to: self)
    @jobs << ProduceJob.new(:table, at: self)

    # puts "REQUESTED TABLE"
    # @jobs.group_by{|j| j.class }.map{|k, v| { k => v.count} }.reduce({}, :merge).each do |class_job, count|
    #   puts "#{class_job} => #{count}"
    # end

    # p @jobs
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
    if @stage == :finished
      @supplies << item
    elsif @stage == :blueprint
      if @needs.include?(item.type)
        @needs.delete(item.type)
        if @needs.empty?
          @stage = :building
          @mask.color = "gray"
          @mask.color.opacity = 0.8

          build_job = BuildJob.new(structure: self)
          $job_list.add(build_job)
        end
      else
        require "pry"
        binding.pry
        raise ArgumentError, "Incorrect item brought"
      end
    end
  end

  def finished_building!
    @mask.color = "green"
    @mask.color.opacity = 0.6
    @stage = :finished
  end

  def building_time
    20.minutes
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
