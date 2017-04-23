require_relative "./base"

class PastureZone < Zone::Base
  attr_reader :x, :y, :image

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
    @x = x_range.to_a.first
    @y = y_range.to_a.first
    @width  = x_range.last - x_range.first + 1
    @height = y_range.last - y_range.first + 1

    @image = Rectangle.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      @width * PIXELS_PER_SQUARE,
      @height * PIXELS_PER_SQUARE,
      "yellow"
    )
    @image.color.opacity = 0.07

    @image.remove
    @image.add

    # TODO: There should be a menu for assigning animals
    # TODO: To pastures

    $creatures_list.each do |creature|
      creature.pasture = self
    end
  end

  def get_job(job_type)
  end
end
