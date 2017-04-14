class GameMode
  class Base
    class Point
      def initialize
        @mouse_background_drawer = MouseBackgroundDrawer.new
        @mouse_background_drawer.remove
      end

      def mouse_down(x, y)
        in_game_x = x / PIXELS_PER_SQUARE
        in_game_y = y / PIXELS_PER_SQUARE
        perform(in_game_x, in_game_y)
        $characters_list.find_all{|char| char.job.is_a? ChillJob}.each(&:finish)
      end

      def mouse_up(x, y)
      end

      def click(x, y)
        mouse_down(x, y)
      end

      def perform(x, y)
      end

      def abort
      end

      def unhover
        @mouse_background_drawer.remove
      end

      def hover(x, y)
        @mouse_background_drawer.render(x, y)
      end
    end

    class Area
      def initialize
        @mouse_background_drawer = MouseBackgroundDrawer.new
        @mouse_background_drawer.remove
      end

      def unhover
        @mouse_background_drawer.remove
      end

      # def warning!
      #   @mouse_down_mask.color = "red"
      # end

      # def ok!
      #   @mouse_down_mask.color = "white"
      # end

      def terrain_clear?(x_range, y_range)
        fields = x_range.to_a.product(y_range.to_a)

        fields.all? do |arr|
          GameWorld.things_at(arr[0], arr[1]).empty?
        end
      end

      def hover(x, y)
        if @hide_background_drawer

          @x_arr = [@x_start, x].sort
          @y_arr = [@y_start, y].sort

          @mouse_down_mask.remove
          @mouse_down_mask = nil

          rect_x      = @x_arr.first * PIXELS_PER_SQUARE
          rect_y      = @y_arr.first * PIXELS_PER_SQUARE
          rect_width  = (@x_arr.last - @x_arr.first + 1) * PIXELS_PER_SQUARE
          rect_height = (@y_arr.last - @y_arr.first + 1) * PIXELS_PER_SQUARE

          @mouse_down_mask = Rectangle.new(
            rect_x,
            rect_y,
            rect_width,
            rect_height,
            [1, 1, 1, 0.2]
          )
        else
          @mouse_background_drawer.render(x, y)
        end
      end

      def abort
        @mouse_down_mask and @mouse_down_mask.remove
        @mouse_down_mask = nil
        @x_start = nil
        @y_start = nil
        @x_arr   = nil
        @y_arr   = nil
        @hide_background_drawer = nil
      end

      def click(x, y)
        mouse_down(x, y)
        mouse_up(x, y)
      end

      def mouse_down(x, y)
        in_game_x = x / PIXELS_PER_SQUARE
        in_game_y = y / PIXELS_PER_SQUARE

        @mouse_background_drawer.remove
        @hide_background_drawer = true

        @x_start = in_game_x
        @y_start = in_game_y

        @x_arr = [@x_start, @x_start].sort
        @y_arr = [@y_start, @y_start].sort

        rect_x      = @x_arr.first * PIXELS_PER_SQUARE
        rect_y      = @y_arr.first * PIXELS_PER_SQUARE
        rect_width  = (@x_arr.last - @x_arr.first + 1) * PIXELS_PER_SQUARE
        rect_height = (@y_arr.last - @y_arr.first + 1) * PIXELS_PER_SQUARE

        @mouse_down_mask = Rectangle.new(
          rect_x,
          rect_y,
          rect_width,
          rect_height,
          [1, 1, 1, 0.2]
        )
      end

      def mouse_up(x, y)
        in_game_x = x / PIXELS_PER_SQUARE
        in_game_y = y / PIXELS_PER_SQUARE

        if @hide_background_drawer
          @x_arr = [@x_start, in_game_x].sort
          @y_arr = [@y_start, in_game_y].sort

          x_range = (@x_arr.first..@x_arr.last)
          y_range = (@y_arr.first..@y_arr.last)

          perform(x_range, y_range)

          @hide_background_drawer = nil
          @mouse_down_mask.remove
          @mouse_down_mask = nil
        end

        @mouse_background_drawer.render(in_game_x, in_game_y)
        $characters_list.find_all{|char| char.job.is_a? ChillJob}.each(&:finish)
      end
    end
  end
end
