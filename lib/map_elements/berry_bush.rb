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
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/berrybush.png")
    @picked = false
    @grams = 4500 + rand * 1000
  end

  def get_berries(seconds)
    grams = gathered_grams(seconds)
    @grams -= grams

    if @grams <= 0
      @picked = true
      unless @finished_mask
        @finished_mask = Square.new(@x * PIXELS_PER_SQUARE, @y * PIXELS_PER_SQUARE, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])
      end
    end

    Berries.new(grams)
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
    @image.remove
  end

  private

  def gathered_grams(seconds)
    if gathered_grams_per_second * seconds > @grams 
      @grams 
    else
      gathered_grams_per_second * seconds
    end
  end

  # Gather a cup (148 grams) in 5 minutes
  # so in second 148.0 / (5 * 60)
  def gathered_grams_per_second
    0.493
  end
end
