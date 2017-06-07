class Crate < Container
  class Inspection
    def initialize(crate, opts = {})
      @x = opts[:x]
      @y = opts[:y]
      @texts = []
      @texts << Text.new(
        x: @x,
        y: @y,
        text: "Crate, stored:",
        size: 16,
        font: "fonts/arial.ttf"
      )
      crate.storage.each_with_index do |thing, index|
        @texts << Text.new(
          x: @x + 10,
          y: @y + 20 * (1 + index),
          text: thing.inspect,
          size: 16,
          font: "fonts/arial.ttf"
        )
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

    @background = MapRenderer.square(x, y, 1, "brown", z_index)
    @image = MapRenderer.image(x, y, "assets/structures/crate.png", z_index, "black")
  end

  def x=(x)
    @x = x
    @image.x = x
    @background.x = x
  end

  def y=(y)
    @y = y
    @image.y = y
    @background.y = y
  end

  def remove
    @image.remove
    @background.add
  end

  def render
    @background.add
    @image.add
  end

  def accepts?(thing)
    storage.count < 10 and (thing == :material or thing.category == :material)
  end

  def category
    :container
  end
end
