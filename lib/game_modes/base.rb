class GameMode
  class Base
    def click(x, y)
      in_game_x = x / PIXELS_PER_SQUARE
      in_game_y = y / PIXELS_PER_SQUARE
      perform(in_game_x, in_game_y)
    end
  end
end
