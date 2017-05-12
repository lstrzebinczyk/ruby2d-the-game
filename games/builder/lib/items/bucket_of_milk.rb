class BucketOfMilk < Item
  def initialize(x, y)
    @x, @y = x, y

    @image = MapRenderer.image(x, y, "assets/structures/bucket.png", z_index)
    @litres = 1.9
  end

  def inspect
    "BucketOfMilk, #{@litres}l"
  end

  def category
    :food
  end

  def calories
    @litres * calories_per_liter
  end

  def eating_time
    10.minutes
  end

  # 250ml is 168calories
  # Therefore...
  def calories_per_liter
    672
  end
end
