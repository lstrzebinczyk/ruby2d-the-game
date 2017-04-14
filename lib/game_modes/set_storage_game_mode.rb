class SetStorageGameMode < GameMode::Base::Area
  def hover(x, y)
    super(x, y)

    if @hide_background_drawer
      x_range = (@x_arr.first..@x_arr.last)
      y_range = (@y_arr.first..@y_arr.last)

      if terrain_clear?(x_range, y_range)
        @mouse_down_mask.color = "white"
        @mouse_down_mask.color.opacity = 0.2
      else
        @mouse_down_mask.color = "red"
        @mouse_down_mask.color.opacity = 0.2
      end
    end
  end

  def perform(in_game_x_range, in_game_y_range)
    if terrain_clear?(in_game_x_range, in_game_y_range)
      $zones << StorageZone.new(in_game_x_range, in_game_y_range)
    end
  end
end
