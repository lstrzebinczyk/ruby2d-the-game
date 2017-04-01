class BerriesPile
  class Inspection
    def initialize(berries_pile, opts = {})
      kgs = (berries_pile.grams / 1000).round(2)
      msg = "Berries Pile, #{kgs} kg of berries"
      x = opts[:x]
      y = opts[:y]
      @t = Text.new(x, y, msg, 16, "fonts/arial.ttf")
    end

    def remove
      @t.remove
    end
  end


  def self.unit
    "kgs"
  end

  attr_reader :x, :y

  def initialize(x, y, grams)
    @x       = x
    @y       = y
    @berries = Berries.new(grams)

    rerender
  end

  def grams
    @berries.grams
  end

  def pickable?
    true
  end

  def count
    (@berries.grams / 1000).round(2)
  end

  def remove
    @image && @image.remove
  end

  def can_carry_more?
    true
  end

  def rerender
    remove
    unless count == 0
      message = "Br"
      @image = Text.new(@x * PIXELS_PER_SQUARE, @y * PIXELS_PER_SQUARE, message, 10, "fonts/arial.ttf")
    end
  end

  def get_item
    amount = [700, @berries.grams].min
    @berries.get_grams(amount)
  end

  def put(item)
    if item.is_a? Berries
      @berries += item
      rerender
    else
      raise "You can't put #{item.class} to a berries pile"
    end
  end

  def passable?
    true
  end
end
