class Fireplace < Structure::Base
  def self.size
    1
  end

  def initialize
    @position = $map.passable_spots_near($characters_list.first).first
    x = @position.x * PIXELS_PER_SQUARE
    y = @position.y * PIXELS_PER_SQUARE
    @image_burning  = Image.new(x, y, "assets/structures/campfire.png", ZIndex::STRUCTURE)
    @image_extinguished  = Image.new(x, y, "assets/structures/campfireextunguished.png", ZIndex::STRUCTURE)
    @image_extinguished.remove
    @burning = true

    @opacity = 0.08

    inner_x = (@position.x - 1) * PIXELS_PER_SQUARE
    inner_y = (@position.y - 1) * PIXELS_PER_SQUARE
    @inner_square = Square.new(inner_x, inner_y, 3 * PIXELS_PER_SQUARE, [1, 1, 0, @opacity], ZIndex::STRUCTURE + 0.1)

    outer_x = (@position.x - 2) * PIXELS_PER_SQUARE
    outer_y = (@position.y - 2) * PIXELS_PER_SQUARE
    @outer_square = Square.new(outer_x, outer_y, 5 * PIXELS_PER_SQUARE, [1, 1, 0, @opacity], ZIndex::STRUCTURE + 0.1)
  end

  def x
    @position.x
  end

  def y
    @position.y
  end

  def impassable?
    true
  end

  def rerender
    @image_burning.remove
    @image_burning.add

    @inner_square.remove
    @inner_square.add

    @outer_square.remove
    @outer_square.add
  end

  def update(current_time)
    if current_time.day?
      if @burning
        @image_burning.remove
        @inner_square.remove
        @outer_square.remove

        @image_extinguished.add
        @burning = false
      end
    else
      if @burning
        if rand < 0.2 / $game_speed.value
          @inner_square.color.opacity = @opacity * 2 + rand / 15
        end
        if rand < 0.2 / $game_speed.value
          @outer_square.color.opacity = @opacity + rand / 20
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
