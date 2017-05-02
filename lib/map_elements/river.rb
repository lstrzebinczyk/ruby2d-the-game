class River
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @offset_x = $map_position.offset_x
    @offset_y = $map_position.offset_y
    @image  = Image.new(
      @x * PIXELS_PER_SQUARE + @offset_x,
      @y * PIXELS_PER_SQUARE + @offset_y,
      "assets/nature/river.png"
    )
    $map_position.add_observer(self, :update_offset)
  end

  def update_offset(offset_x, offset_y)
    @offset_x = offset_x
    @offset_y = offset_y

    @image.x = @x * PIXELS_PER_SQUARE + @offset_x
    @image.y = @y * PIXELS_PER_SQUARE + @offset_y
  end

  def remove
    @image.remove
  end

  def render
    @image.add
  end

  def passable?
    false
  end
end
