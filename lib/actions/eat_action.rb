class EatAction < Action::Base
  def initialize(character)
    @character = character 
  end

  def start
    unless @character.carry.is_a? Berries
      raise ArgumentError, "Something is no yes"
    end
  end

  def update(seconds)
    if @character.has_something_to_eat?
      @character.eat(seconds)
    else
      @character.carry = nil
      end_action
    end
  end
end
