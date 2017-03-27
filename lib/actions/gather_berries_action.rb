# TODO: MAKE IT SIMPLE FOR NOW
# gather berries for 30 minutes
# and eat them next 30 minutes
# Gathered 1 kilogram of berries (lol)

# this should produce good quality meal
# for NOW

# TODO: MAKE THIS REALISTIC AND BASED ON CALORIES INTAKE

class GatherBerriesAction < Action::Base
  def initialize(character, berries)
    @character = character 
    @berries   = berries
    @time_left = 30.minutes
  end

  def update(seconds)
    @time_left -= seconds
    if @time_left <= 0 
      @character.carry = Berries.new(1000)
      end_action
    end
  end
end
