class Berries < Item
  attr_reader :x, :y, :count

  def initialize(x, y, grams)
    @x, @y = x, y
    @grams = grams

    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/berries.png")
    @image.color = "purple"

    @count = 1
  end

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
  end

  def get_item
    @count = 0
    self
  end

  def remove
    @image.remove
  end

  def category
    :food
  end

  def passable?
    true
  end

  def picking_time
    15
  end

  def pickable?
    true
  end

  # 148g (a cup) -> 84.4 calories
  # 1g -> 0.57
  def calories_per_gram
    0.57
  end

  # assume 5 minutes for cup (148 gram)
  # thats 5 * 60 / 148 grams eaten per second
  def grams_eaten_per_second
    2.027
  end

  def calories_eaten_in(seconds)
    grams_eaten = seconds * grams_eaten_per_second
    @grams -= grams_eaten
    grams_eaten * calories_per_gram
  end

  def empty?
    @grams <= 0
  end
end
