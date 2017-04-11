# Log is thought of as a 2 meter long, almost 1 meter wide piece of wood
# That is produced by cutting a tree
class Log < Item
  attr_reader :x, :y, :count

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/log.png")
    @image.color = "brown"
    # TODO: Picking and storing system must be better thought
    @count = 1
  end

  def category
    :material
  end

  def remove
    @image.remove
  end

  def type
    :log
  end

  def passable?
    true
  end

  def picking_time
    5
  end

  def can_carry_more?(item_class)
    false
  end

  def get_item
    @count = 0
    self
  end

  def pickable?
    true
  end

  def contains?(item_type)
    item_type == :log
  end
end
