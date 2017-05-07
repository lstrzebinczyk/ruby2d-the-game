module MapRenderer
  class MapRenderable
    def add
      @content.add
    end

    def remove
      @content.remove
    end

    def x=(x)
      @content.x = x * PIXELS_PER_SQUARE
    end

    def y=(y)
      @content.y = y * PIXELS_PER_SQUARE
    end

    def color=(color)
      @content.color = color
    end
  end

  class MapImage < MapRenderable
    def initialize(x, y, path, z)
      @content = Image.new(x, y, path, z)
    end
  end

  class MapSquare < MapRenderable
    def initialize(x, y, size, color, z)
      @content = Square.new(x, y, size, color, z)
    end

    def color
      @content.color
    end
  end

  def self.image(x, y, path, z = 0, color = nil)
    image = MapImage.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      path,
      z
    )
    image.color = color unless color.nil?
    image
  end

  def self.square(x, y, size, color = "black", z = 0)
    MapSquare.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      size * PIXELS_PER_SQUARE,
      color,
      z
    )
  end
end
