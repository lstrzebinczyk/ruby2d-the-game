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
      "brown",
      z_index
    )
    @image = Image.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      "assets/structures/barrel.png",
      z_index + 0.1
    )
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
    @background.remove
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

  def after_put_callback
    storage.sort!{|a, b| -a.calories <=> -b.calories }
  end
end
