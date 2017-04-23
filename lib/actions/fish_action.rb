class FishAction < Action::Base
  def initialize(character)
    @character = character
    @time_left = 2.hour
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      empty_spot = $map.free_spots_near(@character).first
      fish = RawFish.new(empty_spot.x, empty_spot.y)
      $map[empty_spot.x, empty_spot.y].content = fish

      end_action
    end
  end
end
