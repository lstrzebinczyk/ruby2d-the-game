class Fishery < Structure::Base
  class Inspection
    def initialize(kitchen, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Fishery", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 20, "Continuous fishing:  on", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 40, "Continuous cleaning: on", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 60, "Raw fishes: #{kitchen.supplies.count}", 16, "fonts/arial.ttf")
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :supplies, :jobs

  def self.structure_requirements
    [Table]
  end

  def self.building_time
    20.minutes
  end

  def self.size
    3
  end

  def self.buildable_items
    []
  end

  def initialize(x, y)
    @x, @y = x, y
    @size  = self.class.size

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "purple")
    @mask.color.opacity = 0.6

    @supplies = []
    @jobs     = []
  end

  def get_job(type)
    if type == :fish_cleaning
      if supplies.any?
        FishCleaningJob.new(at: self)
      end
    elsif type == :fishing
      FishingJob.new
    elsif type == :haul
      unless supplies.count >= 10
        supply_job = SupplyJob.new(RawFish, to: self)
        supply_job if supply_job.available?
      end
    end
  end
    # @jobs     = []


  # TODO: THis must be handled better if there will be duplications
  # like [Log, Log]
  def has_stuff_required_for(item_class)
    item_class.required_supplies.each do |requirement|
      @supplies.any?{|s| s.is_a? requirement }
    end
  end

  # def request(item_class)
  #   item_class.required_supplies.each do |supply|
  #     @jobs << SupplyJob.new(supply, to: self)
  #   end
  #   @jobs << ProduceJob.new(item_class, at: self)
  # end

  # TODO: Always use classes like Table, Barrel to pass around instead of hashes.
  def produce(item_class)
    item_class.required_supplies.each do |requirement|
      supply = @supplies.find{|el| el.is_a? requirement}
      @supplies.delete(supply)
    end
    spot = $map.find_empty_spot_near(self)
    $map[spot.x, spot.y] = item_class.new(spot.x, spot.y)
    nil
  end

  def supply(item)
    @supplies << item
  end
end
