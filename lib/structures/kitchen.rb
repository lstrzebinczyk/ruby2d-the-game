# TODO: MAKE THE KITCHEN ACTUALLY BUILDABLE
# TODO: Like, require wood and time and stuff

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

  attr_reader :x, :y, :size, :ensure_berries_kgs

  def initialize(x, y)
    @x, @y = x, y
    @size  = 3

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "brown")
    @mask.color.opacity = 0.6

    @ensure_berries_kgs = 0.0
  end

  def ensure_more_berries
    @ensure_berries_kgs += 0.1
  end

  def ensure_less_berries
    @ensure_berries_kgs -= 0.1
    if @ensure_berries_kgs <= 0.0
      @ensure_berries_kgs = 0.0
    end
  end  

  def update(time)
  end
end
