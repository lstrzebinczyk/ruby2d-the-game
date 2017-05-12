class Kitchen < Structure::Base
  class Inspection
    def initialize(kitchen, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Kitchen", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 20, "Continuous cooking: on", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 40, "Cleaned fishes: #{kitchen.supplies.count}", 16, "fonts/arial.ttf")
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :size, :supplies, :jobs

  def self.structure_requirements
    [Table]
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

    @mask = MapRenderer.square(x, y, 3, "brown", ZIndex::STRUCTURE)
    @mask.color.opacity = 0.6

    @table = MapRenderer.image(
      x + 1,
      y + 1,
      "assets/structures/table.png",
      ZIndex::STRUCTURE + 0.1,
      "brown"
    )

    @jobs     = []
    @supplies = []
  end

  def get_job(type)
    if type == :cooking
      if supplies.any?
        ProduceJob.new(CookedFish, at: self, type: :cooking)
      end
    elsif type == :haul
      unless supplies.count >= 10
        supply_job = SupplyJob.new(CleanedFish, to: self)
        supply_job if supply_job.available?
      end
    end
  end

  def has_stuff_required_for(item_class)
    item_class.required_supplies.each do |requirement|
      @supplies.any?{|s| s.is_a? requirement }
    end
  end

  def produce(item_class)
    item_class.required_supplies.each do |requirement|
      supply = @supplies.find{|el| el.is_a? requirement}
      @supplies.delete(supply)
    end
    spot = $map.free_spots_near(self).first
    $map[spot.x, spot.y].content = item_class.new(spot.x, spot.y)
    nil
  end

  def supply(item)
    @supplies << item
  end
end
