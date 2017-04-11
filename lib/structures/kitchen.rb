class Kitchen < Structure::Base
  class Inspection
    def initialize(kitchen, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, Kitchen.name, 16, "fonts/arial.ttf")

      msg = "Ensure berries: #{kitchen.ensure_berries_kgs.round(2)} kg"
      @texts << Text.new(x, y + 20, msg, 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 40, "Press n to decrease", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 60, "Press m to increase", 16, "fonts/arial.ttf")
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :size, :ensure_berries_kgs, :supplies

  def self.structure_requirements
    [:table]
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

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "brown")
    @mask.color.opacity = 0.6

    @table = Image.new(
      (x + 1) * PIXELS_PER_SQUARE,
      (y + 1) * PIXELS_PER_SQUARE, "assets/structures/table.png"
    )
    @table.color = "brown"


    @ensure_berries_kgs = 0.0
  end

  def has_job?(type)
    if type == :gathering
      # Yes, if there are not enough stored berried
      current_berries_grams  = $zones.grouped_count[BerriesPile] || 0

      current_berries_grams < @ensure_berries_kgs
    else
      false
    end
  end

  def get_job(type)
    if type == :gathering
      if ($zones.grouped_count[BerriesPile] || 0) < @ensure_berries_kgs
        berry_bush = $map.find_closest_to(self) do |map_object|
          map_object.is_a? BerryBush and map_object.has_more?
        end

        PickBerryBushJob.new(berry_bush)
      end
    else
    end
  end

  def ensure_more_berries
    @ensure_berries_kgs += 0.3
  end

  def ensure_less_berries
    @ensure_berries_kgs -= 0.3
    if @ensure_berries_kgs <= 0.0
      @ensure_berries_kgs = 0.0
    end
  end
end
