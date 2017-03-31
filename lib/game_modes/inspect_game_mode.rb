class InspectGameMode < GameMode::Base
  def perform(in_game_x, in_game_y)
    unless $map[in_game_x, in_game_y].nil?
      $inspection_menu.set_mode(:inspect)
    end
  end
end
