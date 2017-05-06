# Log is thought of as a 2 meter long, almost 1 meter wide piece of wood
# That is produced by cutting a tree
class Log < Item
  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      "assets/nature/log.png",
      z_index
    )
    @image.color = "brown"
  end

  def category
    :material
  end

  def rerender
    @image.remove
    @image.add
  end
end
