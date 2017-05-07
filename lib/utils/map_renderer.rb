module MapRenderer
  class MapRenderable
    def initialize(x, y)
      @x = x
      @y = y
      @x_offset = $map_position.offset_x
      @y_offset = $map_position.offset_y
      $map_position.add_observer(self, :update_offset)
    end

    def add
      @x_offset = $map_position.offset_x
      @y_offset = $map_position.offset_y
      $map_position.add_observer(self, :update_offset)
      @content.x = @x * PIXELS_PER_SQUARE + @x_offset
      @content.y = @y * PIXELS_PER_SQUARE + @y_offset
      @content.add
    end

    def remove
      @content.remove
      $map_position.delete_observer(self)
    end

    def x=(x)
      @x = x
      @content.x = @x * PIXELS_PER_SQUARE + @x_offset
    end

    def y=(y)
      @y = y
      @content.y = @y * PIXELS_PER_SQUARE + @y_offset
    end

    def color=(color)
      @content.color = color
    end

    def color
      @content.color
    end

    def update_offset(x_offset, y_offset)
      @x_offset = x_offset
      @y_offset = y_offset

      @content.x = @x * PIXELS_PER_SQUARE + @x_offset
      @content.y = @y * PIXELS_PER_SQUARE + @y_offset
    end
  end

  class MapImage < MapRenderable
    def initialize(x, y, path, z)
      @content = Image.new(
        x * PIXELS_PER_SQUARE,
        y * PIXELS_PER_SQUARE,
        path,
        z
      )
      super(x, y)
    end
  end

  class MapSquare < MapRenderable
    def initialize(x, y, size, color, z)
      @content = Square.new(
        x * PIXELS_PER_SQUARE,
        y * PIXELS_PER_SQUARE,
        size * PIXELS_PER_SQUARE,
        color,
        z
      )
      super(x, y)
    end
  end

  class MapRectangle < MapRenderable
    def initialize(x, y, width, height, color, z)
      @content = Rectangle.new(
        x * PIXELS_PER_SQUARE,
        y * PIXELS_PER_SQUARE,
        width * PIXELS_PER_SQUARE,
        height * PIXELS_PER_SQUARE,
        color,
        z
      )
      super(x, y)
    end
  end

  def self.image(x, y, path, z = 0, color = nil)
    image = MapImage.new(x, y, path, z)
    image.color = color unless color.nil?
    image
  end

  def self.square(x, y, size, color = "black", z = 0)
    MapSquare.new(x, y, size, color, z)
  end

  def self.rectangle(x, y, width, height, color = "black", z = 0)
    MapRectangle.new(x, y, width, height, color, z)
  end
end
