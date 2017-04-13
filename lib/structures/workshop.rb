class Workshop < Structure::Base
  class Inspection
    def initialize(workshop, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Workshop", 16, "fonts/arial.ttf")

      count = workshop.jobs.count{|j| j.is_a? ProduceJob and j.item_type == :table }
      msg = "Request tables: #{count}"
      @texts << Text.new(x, y + 20, msg, 16, "fonts/arial.ttf")
      # @texts << Text.new(x, y + 40, "Press k to decrease", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 60, "Press l to increase", 16, "fonts/arial.ttf")

      count = workshop.jobs.count{|j| j.is_a? ProduceJob and j.item_type == :barrel }
      msg = "Request barrels: #{count}"
      @texts << Text.new(x, y + 120, msg, 16, "fonts/arial.ttf")
      # @texts << Text.new(x, y + 40, "Press k to decrease", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 160, "Press k to increase", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 180, "Supplies:", 16, "fonts/arial.ttf")
      logs_count = workshop.supplies.count{|thing| thing.is_a? Log }
      @texts << Text.new(x, y + 200, "Logs: #{logs_count}", 16, "fonts/arial.ttf")


    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :supplies

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

  def has_stuff_required_for(item_type)
    if item_type == :table
      @supplies.any?{|s| s.type == :log }
    elsif item_type == :barrel
      @supplies.any?{|s| s.type == :log }
    end
  end

  def request(item_class)
    item_class.required_supplies.each do |supply|
      @jobs << SupplyJob.new(supply, to: self)
    end
    @jobs << ProduceJob.new(item_class.type, at: self)
  end

  # TODO: Always use classes like Table, Barrel to pass around instead of hashes.
  def produce(item_type)
    if item_type == :table
      log = @supplies.find{|el| el.is_a? Log}
      @supplies.delete(log)
      spot = $map.find_free_spot_near(self)
      item = Table.new(spot.x, spot.y)
      $map[spot.x, spot.y] = item
      item
    end

    if item_type == :barrel
      log = @supplies.find{|el| el.is_a? Log}
      @supplies.delete(log)
      spot = $map.find_free_spot_near(self)
      item = Barrel.new(spot.x, spot.y)
      $map[spot.x, spot.y] = item
      item
    end
  end

  def supply(item)
    @supplies << item
  end
end
