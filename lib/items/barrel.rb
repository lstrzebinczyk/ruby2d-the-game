class Container < Item
  def storage
    @storage ||= []
  end

  def put(thing)
    storage << thing
  end

  def contains?(item_class)
    storage.any?{ |item| item.is_a? item_class }
  end

  def get_something
    storage.shift
  end
end

class Barrel < Container
  class Inspection
    def initialize(barrel, opts = {})
      @x = opts[:x]
      @y = opts[:y]
      @texts = []
      @texts << Text.new(@x, @y, "Barrel, stored:", 16, "fonts/arial.ttf")
      barrel.storage.each_with_index do |thing, index|
        @texts << Text.new(@x + 10, @y + 20 * (1 + index), thing.inspect, 16, "fonts/arial.ttf")
      end
    end

    def remove
      @texts.each(&:remove)
    end
  end

  def self.required_supplies
    [Log]
  end

  def initialize(x, y)
    @x, @y = x, y

    @background = Square.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      PIXELS_PER_SQUARE,
      "brown"
    )
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/structures/barrel.png")
    @image.color = "black"
  end

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
    @background.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
    @background.y = y * PIXELS_PER_SQUARE
  end

  def remove
    @image.remove
    @background.add
  end

  def accepts?(thing)
    storage.count < 10 and (thing == :food or thing.category == :food)
  end

  def render
    @background.add
    @image.add
  end

  def category
    :container
  end
end
