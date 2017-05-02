class ConstructGameMode < GameMode::Base::Point
  def initialize(structure_class)
    super()
    @structure_class = structure_class
                     # TODO
    @cursor_size = 1 # Now that is always a wall. Move to proper classes later
  end

  def perform(in_game_x, in_game_y)
    if terrain_clear?(in_game_x, in_game_y)
      new_construction = @structure_class::Blueprint.new(in_game_x, in_game_y)
      $constructions << new_construction

      $constructions.find_all do |construction|
        construction.is_a?(@structure_class::Blueprint) and (construction.x - new_construction.x).abs <= 1 and (construction.y - new_construction.y).abs <= 1
      end.each do |neighbor|
        neighbor.update_image
      end
    end
  end

  def unhover
    @mask && @mask.remove
  end

  def hover(x, y)
    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @cursor_size * PIXELS_PER_SQUARE)
    if terrain_clear?(x, y)
      @mask.color = "brown"
    else
      @mask.color = "red"
    end
    @mask.color.opacity = 0.6
  end

  def terrain_clear?(x, y)
    fields = (x..(x+@cursor_size-1)).to_a.product((y..(y+@cursor_size-1)).to_a)

    fields.all? do |arr|
      GameWorld.things_at(arr[0], arr[1]).empty?
    end
  end
end
