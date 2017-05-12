# Log is thought of as a 2 meter long, almost 1 meter wide piece of wood
# That is produced by cutting a tree
class Log < Item
  def initialize(x, y)
    @x, @y = x, y
    @image = MapRenderer.image(x, y, "assets/nature/log.png", z_index, "brown")
  end

  def category
    :material
  end
end
