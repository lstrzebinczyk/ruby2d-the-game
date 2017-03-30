class SleepAction < Action::Base
  def initialize(character)
    @character = character
    @energy_per_second = 2.3 * 0.00104167 / 60
  end
  # Energy per second for:
  # 2.3 * 0.00104167 / 60 # FIREPLACE
  # 2.6 * 0.00104167 / 60 # DORMITORY
  # 3.0 * 0.00104167 / 60 # OWN BED
  # Currently only can sleep near fireplace

  def start
    unless @character.state == :sleeping
      @character.state = :sleeping
    else
      raise ArgumentError, "error!"
    end
  end

  def update(seconds)
    @character.energy += @energy_per_second * seconds
    @character.energy = 1.0 if @character.energy > 1

    if done_sleeping?
      @character.state = :working
      end_action
    end
  end

  private

  def done_sleeping?
    $day_and_night_cycle.time.hour >= 6 and @character.energy > 0.85
  end
end
