class GatherBerriesAction < Action::Base
  def initialize(character, berries)
    @character = character 
    @berries   = berries
    @time_left = 30.minutes
  end

  def gathered_grams(seconds)
    gathered_grams_per_second * seconds
  end

  # Gather a cup (148 grams) in 5 minutes
  # so in second 148.0 / (5 * 60)
  def gathered_grams_per_second
    0.493
  end

  def update(seconds)
    @time_left -= seconds
    if @time_left <= 0 
      grams = gathered_grams(30.minutes)
      @character.carry = Berries.new(grams)
      end_action
    end
  end
end
