class BuildWorkshopGameMode < GameMode::Base::Point
  def perform(in_game_x, in_game_y)
    if terrain_clear?(in_game_x, in_game_y)
      $structures << Blueprint.new(Workshop, in_game_x, in_game_y)
      if $menu
        $menu.set_game_mode(:inspect)
      end
      unhover
      @mask = nil
    end
  end

  def unhover
    @mask && @mask.remove
  end

  def hover(x, y)
    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE)
    if terrain_clear?(x, y)
      @mask.color = "brown"
    else
      @mask.color = "red"
    end
    @mask.color.opacity = 0.6
  end

  def terrain_clear?(x, y)
    fields = (x..(x+2)).to_a.product((y..(y+2)).to_a)

    fields.all? do |arr|
      GameWorld.things_at(arr[0], arr[1]).empty?
    end
  end
end
