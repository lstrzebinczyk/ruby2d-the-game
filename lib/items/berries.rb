class Berries < Item
  def initialize(x, y, grams)
    @x, @y = x, y
    @grams = grams

    @image = MapRenderer.image(x, y, "assets/nature/berries.png", z_index, "purple")
  end

  def inspect
    "Berries, #{kilograms}kg"
  end

  def kilograms
    (@grams / 1000.0).round(2)
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
