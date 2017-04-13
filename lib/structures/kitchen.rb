class Kitchen < Structure::Base
  class Inspection
    def initialize(kitchen, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, Kitchen.name, 16, "fonts/arial.ttf")
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :x, :y, :size, :supplies

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

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "brown")
    @mask.color.opacity = 0.6

    @table = Image.new(
      (x + 1) * PIXELS_PER_SQUARE,
      (y + 1) * PIXELS_PER_SQUARE, "assets/structures/table.png"
    )
    @table.color = "brown"

    @jobs     = []
    @supplies = []
  end
end
