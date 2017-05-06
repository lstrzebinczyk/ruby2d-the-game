module MapRenderer
  def self.image(x, y, path, z = 0, color = nil)
    image = Image.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      path,
      z
    )
    image.color = color unless color.nil?
    image
  end

  def self.square(x, y, size, color = "black", z = 0)
    Square.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      size * PIXELS_PER_SQUARE,
      color,
      z
    )
  end
end
