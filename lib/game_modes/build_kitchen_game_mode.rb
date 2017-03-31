class BuildKitchenGameMode < GameMode::Base
  def perform(in_game_x, in_game_y)

  end

  def unhover
    @mask && @mask.remove
  end

  def hover(x, y)
    if @mask
      @mask.x = x * PIXELS_PER_SQUARE
      @mask.y = y * PIXELS_PER_SQUARE
      @mask.add
    else
      @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "brown")
      @mask.color.opacity = 0.6
    end
  end
end
