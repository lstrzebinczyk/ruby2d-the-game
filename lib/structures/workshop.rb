class Workshop < Structure::Base
  class Inspection
    def initialize(workshop, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Workshop", 16, "fonts/arial.ttf")

      count = workshop.jobs.count{|j| j.is_a? ProduceJob and j.item_class == Table }
      msg = "Request tables: #{count}"
      @texts << Text.new(x, y + 20, msg, 16, "fonts/arial.ttf")
      # @texts << Text.new(x, y + 40, "Press k to decrease", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 60, "Press l to increase", 16, "fonts/arial.ttf")

      count = workshop.jobs.count{|j| j.is_a? ProduceJob and j.item_class == Barrel }
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
    [Log]
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

  # TODO: THis must be handled better if there will be duplications
  # like [Log, Log]
  def has_stuff_required_for(item_class)
    item_class.required_supplies.each do |requirement|
      @supplies.any?{|s| s.is_a? requirement }
    end
  end

  def request(item_class)
    item_class.required_supplies.each do |supply|
      @jobs << SupplyJob.new(supply, to: self)
    end
    @jobs << ProduceJob.new(item_class, at: self)
  end

  # TODO: Always use classes like Table, Barrel to pass around instead of hashes.
  def produce(item_class)
    item_class.required_supplies.each do |requirement|
      supply = @supplies.find{|el| el.is_a? requirement}
      @supplies.delete(supply)
    end
    spot = $map.find_free_spot_near(self)
    item = item_class.new(spot.x, spot.y)
    $map[spot.x, spot.y] = item
    item
  end

  def supply(item)
    @supplies << item
  end
end
