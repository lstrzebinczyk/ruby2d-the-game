# TODO: FEATURES FOR BERRY BUSHES
#   - allow for cutting it 
#     - for now it just disappears
#     - later it should produce firewood

#   - allow for harvesting it
#     - it should follow it's own number of berries available (in kilograms)
#     - storing berries in storage should be possible
#     - add second person
#     - have first person only do forestry and carrying, second only for harvesting and carrying
#     - implement eating and having to eat

class BerryBush
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/nature/berrybush.png")
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
end
