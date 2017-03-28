class GatherBerriesAction < Action::Base
  def initialize(character, berries_bush)
    @character    = character 
    @berries_bush = berries_bush
    @time_left    = 30.minutes
  end

  def update(seconds)
    @time_left -= seconds
    if @time_left <= 0 
      @character.carry = @berries_bush.get_berries(30.minutes)
      end_action
    end
  end
end
