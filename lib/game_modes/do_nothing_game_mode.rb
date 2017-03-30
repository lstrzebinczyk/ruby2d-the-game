class DoNothingGameMode < GameMode::Base
  def perform(in_game_x, in_game_y)
    map_element = $map[in_game_x, in_game_y]
    puts "Element in (#{in_game_x}, #{in_game_y}): #{map_element.inspect}"
  end
end
