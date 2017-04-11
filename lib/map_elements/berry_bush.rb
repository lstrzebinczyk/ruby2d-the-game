# TODO: FEATURES FOR BERRY BUSHES
#   - allow for cutting it
#     DONE - for now it just disappears
#     - later it should produce firewood

#   - allow for harvesting it
#     - it should follow it's own number of berries available (in kilograms)
#     - storing berries in storage should be possible
#     - add second person
#     - have first person only do forestry and carrying, second only for harvesting and carrying
#     - implement eating and having to eat

      # - have the bushes regrow at a reasonable, realistic rate

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
  attr_reader :x, :y, :grams

  def initialize(x, y, grams = nil)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/berrybush.png")
    @picked = false
    if grams
      @grams = grams
    else
      @grams = 1500 + (rand * 1000).to_i
    end
  end

  def gathering_time
    @grams / gathered_grams_per_second
  end

  # Max package is 350 grams. That's a big handful.
  def gather_all
    items = []
    max = 350
    full_packets = @grams / max

    full_packets.times do
      items << Berries.new(@x, @y, max)
    end

    items << Berries.new(@x, @y, @grams - full_packets * max)
    items
  end

  def will_get_picked!
    @picked = true
  end

  def was_picked!
    @picked = true
    unless @finished_mask
      @finished_mask = Square.new(@x * PIXELS_PER_SQUARE, @y * PIXELS_PER_SQUARE, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])
    end
  end

  def picked?
    @picked
  end

  def passable?
    true
  end

  def rerender
    remove
    @image.add
  end

  def remove
    @finished_mask && @finished_mask.remove
    @image.remove
  end

  private

  # Gather a cup (148 grams) in 5 minutes
  # so in second 148.0 / (5 * 60)
  def gathered_grams_per_second
    0.493
  end
end
