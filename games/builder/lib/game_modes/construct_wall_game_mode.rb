class ConstructWallGameMode
  def initialize
    @mouse_background_drawer = MouseBackgroundDrawer.new
    @mouse_background_drawer.remove
  end

  def unhover
    @mouse_background_drawer.remove
  end

  def terrain_clear?(x_range, y_range)
    fields = x_range.to_a.product(y_range.to_a)

    fields.all? do |arr|
      GameWorld.things_at(arr[0], arr[1]).empty?
    end
  end

  def hover(x, y)
    if @hide_background_drawer
      @mouse_down_mask && @mouse_down_mask.remove

      if (@x_start - x).abs >= (@y_start - y).abs
        if @x_start > x
          @mouse_down_mask = Rectangle.new(
            x * PIXELS_PER_SQUARE,
            @y_start * PIXELS_PER_SQUARE,
            ((@x_start - x).abs + 1) * PIXELS_PER_SQUARE,
            PIXELS_PER_SQUARE,
            [1, 1, 1, 0.2]
          )
        else
          @mouse_down_mask = Rectangle.new(
            @x_start * PIXELS_PER_SQUARE,
            @y_start * PIXELS_PER_SQUARE,
            ((@x_start - x).abs + 1) * PIXELS_PER_SQUARE,
            PIXELS_PER_SQUARE,
            [1, 1, 1, 0.2]
          )
        end
      else
        if @y_start > y
          @mouse_down_mask = Rectangle.new(
            @x_start * PIXELS_PER_SQUARE,
            y * PIXELS_PER_SQUARE,
            PIXELS_PER_SQUARE,
            ((@y_start - y).abs + 1) * PIXELS_PER_SQUARE,
            [1, 1, 1, 0.2]
          )
        else
          @mouse_down_mask = Rectangle.new(
            @x_start * PIXELS_PER_SQUARE,
            @y_start * PIXELS_PER_SQUARE,
            PIXELS_PER_SQUARE,
            ((@y_start - y).abs + 1) * PIXELS_PER_SQUARE,
            [1, 1, 1, 0.2]
          )
        end
      end
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

  def mouse_up(window_x, window_y)
    x = window_x / PIXELS_PER_SQUARE
    y = window_y / PIXELS_PER_SQUARE

    if (@x_start - x).abs >= (@y_start - y).abs
      if @x_start > x
        (x..@x_start).each do |wall_x|
          perform(wall_x, @y_start)
        end
      else
        (@x_start..x).each do |wall_x|
          perform(wall_x, @y_start)
        end
      end
    else
      if @y_start > y
        (y..@y_start).each do |wall_y|
          perform(@x_start, wall_y)
        end
      else
        (@y_start..y).each do |wall_y|
          perform(@x_start, wall_y)
        end
      end
    end

    @hide_background_drawer = nil
    @mouse_down_mask.remove
    @mouse_down_mask = nil
    @mouse_background_drawer.render(x, y)
    $characters_list.find_all{|char| char.job.is_a? ChillJob}.each(&:finish)
  end

  def perform(in_game_x, in_game_y)
    # if terrain_clear?(in_game_x, in_game_y)
      $structures << Wall::Blueprint.new(in_game_x, in_game_y)
      @mask = nil
    # end
  end
end
