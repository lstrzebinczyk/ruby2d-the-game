class BuildStorageMode
  def click(x, y)
    in_game_x = x / PIXELS_PER_SQUARE
    in_game_y = y / PIXELS_PER_SQUARE
    perform(in_game_x, in_game_y)
  end

  def perform(in_game_x, in_game_y)
    if $zones[in_game_x, in_game_y].nil?
      $zones[in_game_x, in_game_y] = StorageZone.new(in_game_x, in_game_y)
      if $map[in_game_x, in_game_y]
        $map[in_game_x, in_game_y].rerender
      end
    end
  end
end
