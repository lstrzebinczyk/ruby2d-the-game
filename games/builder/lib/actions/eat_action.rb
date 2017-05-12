class EatAction < Action::Base
  def initialize(character)
    @character = character
  end

  def start
    if @character.carry.nil?
      end_action
    else
      @time_left = @character.carry.eating_time
    end
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      @character.calories += @character.carry.calories
      @character.carry = nil
      end_action
    end
  end
end
