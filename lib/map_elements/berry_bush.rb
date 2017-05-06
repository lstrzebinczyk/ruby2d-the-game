class BerryBush
  class Inspection
    def initialize(berry_bush, opts = {})
      kgs = (berry_bush.grams / 1000).round(2)
      msg = "Berry Bush, #{kgs} kgs of berries"
      x = opts[:x]
      y = opts[:y]
      @t = Text.new(x, y, msg, 16, "fonts/arial.ttf")
    end

    def remove
      @t.remove
    end
  end

  attr_reader :grams
  attr_accessor :x, :y

  def initialize(x, y, grams = nil)
    @x, @y = x, y

    @image = MapRenderer.image(x, y, "assets/nature/berrybush.png", ZIndex::MAP_ELEMENT)

    @picked = false
    if grams
      @grams = grams
    else
      @grams = 2500 + (rand * 1000).to_i
    end
  end

  def gathering_time
    @grams / gathered_grams_per_second
  end

  def gather_all
    items = []
    max = 550
    divisions = @grams.divmod(max)

    divisions[0].times do
      items << Berries.new(@x, @y, max)
    end

    items << Berries.new(@x, @y, divisions[1])
    items
  end

  def will_get_picked!
    @picked = true
  end

  def was_picked!
    @picked = true
    unless @finished_mask
      @finished_mask = Square.new(
        @x * PIXELS_PER_SQUARE,
        @y * PIXELS_PER_SQUARE,
        PIXELS_PER_SQUARE,
        [1, 1, 1, 0.2],
        ZIndex::MAP_ELEMENT
      )
    end
  end

  def picked?
    @picked
  end

  def render
    @image.add
  end

  def rerender
    @image.remove
    @image.add
  end

  def remove
    @finished_mask && @finished_mask.remove
    @image.remove
    $map_position.delete_observer(self)
  end

  private

  # Gather a cup (148 grams) in 5 minutes
  # so in second 148.0 / (5 * 60)
  def gathered_grams_per_second
    # 0.493
    # Make it smaller so the game is more dynamic
    0.25
  end
end
