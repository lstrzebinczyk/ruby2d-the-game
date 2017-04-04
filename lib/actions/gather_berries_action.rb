# TODO: Introduce some sort of tools to help gather
# TODO: Gather based not on time, but on how much a character can carry
class GatherBerriesAction < Action::Base
  def initialize(character, berries_bush)
    @character    = character
    @berries_bush = berries_bush
    @time_left    = 30.minutes
  end

  def start
    if @character.carry
      raise ArgumentError, "this is not ok"
    else
      @character.carry = Berries.new(0)
    end
  end

  def update(seconds)
    @time_left -= seconds

    @character.carry += @berries_bush.get_berries(seconds)
    if @time_left <= 0
      end_action
    end
  end
end
