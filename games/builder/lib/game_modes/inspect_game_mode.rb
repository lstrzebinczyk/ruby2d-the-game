class InspectGameMode < GameMode::Base::Point
  def perform(in_game_x, in_game_y)
    found_objects = GameWorld.things_at(in_game_x, in_game_y)
    $inspection_menu.set_mode(:inspect)
    $inspection_menu.content = found_objects
  end
end
