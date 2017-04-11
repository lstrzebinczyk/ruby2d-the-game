class Berries < Item
  def initialize(x, y, grams)
    @x, @y = x, y
    @grams = grams

    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/berries.png")
    @image.color = "purple"
  end

  def category
    :food
  end

  def calories
    @grams * calories_per_gram
  end

  def eating_time
    @grams / grams_eaten_per_second
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
end
