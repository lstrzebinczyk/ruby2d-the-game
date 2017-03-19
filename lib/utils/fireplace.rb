# TODO: Have the fireplace require fuel to be burned
# And have the fire of the light depend on the amount of fuel present
class Fireplace
  def initialize
    @position = $map.find_free_spot_near($character)
    $map[@position.x, @position.y] = self
    x = @position.x * PIXELS_PER_SQUARE
    y = @position.y * PIXELS_PER_SQUARE
    @image_burning  = Image.new(x, y, "assets/structures/campfire.png")
    @image_extinguished  = Image.new(x, y, "assets/structures/campfireextunguished.png")
    @image_extinguished.remove
    @burning = true

    @opacity = 0.08

    color = 'yellow'
    inner_x = (@position.x - 1) * PIXELS_PER_SQUARE
    inner_y = (@position.y - 1) * PIXELS_PER_SQUARE
    @inner_square = Square.new(inner_x, inner_y, 3 * PIXELS_PER_SQUARE, [1, 1, 0, @opacity])

    outer_x = (@position.x - 2) * PIXELS_PER_SQUARE
    outer_y = (@position.y - 2) * PIXELS_PER_SQUARE
    @outer_square = Square.new(outer_x, outer_y, 5 * PIXELS_PER_SQUARE, [1, 1, 0, @opacity])
  end

  def passable?
    false
  end

  def rerender
    @image_burning.remove
    @image_burning.add

    @inner_square.remove
    @inner_square.add

    @outer_square.remove
    @outer_square.add
  end

  # TODO: IMPLEMENT Time#day?
  def update(current_time)
    if current_time.hour > 6 && current_time.hour < 18
      if @burning
        @image_burning.remove
        @inner_square.remove
        @outer_square.remove

        @image_extinguished.add
        @burning = false
      end
    else
      if @burning
        if rand < 0.2
          @inner_square.color = [1, 1, 0, @opacity * 2 + rand / 15 ]
        end
        if rand < 0.2
          @outer_square.color = [1, 1, 0, @opacity     + rand / 20 ]
        end
        rerender
      else
        @image_burning.add
        @inner_square.add
        @outer_square.add

        @image_extinguished.remove
        @burning = true
      end
    end
  end
end
