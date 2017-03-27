# TODO: FOR NOW IT's ASSUMED CHARACTER HAS ONE KG OF BERRIES
# AND EATS IT FOR 30 minutes to replenish 1 food
# 
class EatAction < Action::Base
  def initialize(character)
    @character = character 
    @time_left = 30.minutes
    @started = false
  end

  def update(seconds)
    unless @started
      unless @character.carry.is_a? Berries
        raise ArgumentError, "Something is no yes"
      end
      @started = true
    end
    @character.hunger += seconds * 0.000556
    @time_left -= seconds

    if @time_left <= 0
      @character.carry = nil
      end_action
    end
  end
end
