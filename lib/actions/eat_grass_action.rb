class EatGrassAction < Action::Base
  def initialize(character)
    @character = character
    @time_left = 45.minutes
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      $map[@character.x, @character.y].terrain.grass_eaten!
      @character.calories = Creature::MAX_CALORIES
      end_action
    end
  end
end
