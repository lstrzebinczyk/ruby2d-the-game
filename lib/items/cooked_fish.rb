class CookedFish < Item
  def self.required_supplies
    [CleanedFish]
  end

  def initialize(x, y)
    @x, @y = x, y

    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/fish.png")
    @image.color = "#ff9999"

    @grams = 800 + rand(200)
  end

  def inspect
    "Cooked fish, #{kilograms}kg"
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
    20.minutes
  end

  def calories_per_gram
    1.88
  end
end
