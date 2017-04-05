class SetStorageGameMode < GameMode::Base
  def perform(in_game_x, in_game_y)
    if $zones[in_game_x, in_game_y].nil?
      unless $map[in_game_x, in_game_y].is_a? River
        $zones[in_game_x, in_game_y] = StorageZone.new(in_game_x, in_game_y)
        if $map[in_game_x, in_game_y]
          $map[in_game_x, in_game_y].rerender
        end
      end
    end
  end
end
