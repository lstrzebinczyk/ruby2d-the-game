class BucketOfMilk < Item
  def initialize(x, y)
    @x, @y = x, y

    @image = Square.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      PIXELS_PER_SQUARE,
      "white"
    )
    # @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/fish.png")
    # @image.color = "#ff9999"

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
