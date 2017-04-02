class GameMode
  class Base
    def initialize
      @mouse_background_drawer = MouseBackgroundDrawer.new
      @mouse_background_drawer.remove
    end

    def click(x, y)
      in_game_x = x / PIXELS_PER_SQUARE
      in_game_y = y / PIXELS_PER_SQUARE
      perform(in_game_x, in_game_y)
    end

    def unhover
      @mouse_background_drawer.remove
    end

    def hover(x, y)
      @mouse_background_drawer.render(x, y)
    end
  end
end
