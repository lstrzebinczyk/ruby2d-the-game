class Table < Item
  def self.required_supplies
    [Log]
  end

  def initialize(x, y)
    @x, @y = x, y
    @image = MapRenderer.image(x, y, "assets/structures/table.png", z_index, "brown")
  end

  def category
    :furniture
  end

  def impassable?
    true
  end
end
