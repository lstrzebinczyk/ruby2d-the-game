class Fireplace < Structure::Base
  def self.size
    1
  end

  def initialize
    @position = $map.passable_spots_near($characters_list.first).first


    @image_burning = MapRenderer.image(@position.x, @position.y, "assets/structures/campfire.png", ZIndex::STRUCTURE)
    @image_extinguished = MapRenderer.image(@position.x, @position.y, "assets/structures/campfireextunguished.png", ZIndex::STRUCTURE)

    @image_extinguished.remove
    @burning = true

    @opacity = 0.08

    @inner_square = MapRenderer.square(
      @position.x - 1,
      @position.y - 1,
      3,
      [1, 1, 0, @opacity],
      ZIndex::FIREPLACE_LIGHT
    )

    @outer_square = MapRenderer.square(
      @position.x - 2,
      @position.y - 2,
      5,
      [1, 1, 0, @opacity],
      ZIndex::FIREPLACE_LIGHT
    )
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
