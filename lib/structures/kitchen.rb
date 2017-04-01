class Structure
  def include_any?(fields)
    fields.any? do |f|
      self_fields.include?(f)
    end
  end

  def self_fields
    @self_fields ||= begin
      x_range = (x..(x+size - 1))
      y_range = (y..(y+size - 1))
      
      x_range.to_a.product(y_range.to_a)
    end
  end
end

# TODO: MAKE THE KITCHEN ACTUALLY BUILDABLE
# TODO: Like, require wood and time and stuff

class Kitchen < Structure
  attr_reader :x, :y, :size

  def initialize(x, y)
    @x, @y = x, y
    @size  = 3

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "brown")
    @mask.color.opacity = 0.6
  end
end
