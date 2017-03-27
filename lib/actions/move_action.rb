class MoveAction < Action::Base
  def initialize(from, to, character)
    @from       = from
    @to         = to
    @character  = character
    @path       = calculate_path
    @ticks_left = 4 * @character.speed_multiplier
  end
  
  # 4 meters per second when @character.speed_multiplier == 1
  def update(seconds)
    @ticks_left -= 1
    if @ticks_left == 0
      @ticks_left = 4 * @character.speed_multiplier
      next_step = @path.shift
      if next_step
        @character.update_position(next_step.x, next_step.y)
      else
        end_action
      end
    end

    if @from.x == @to.x and @from.y == @to.y
      end_action
    end
  end

  def calculate_path
    PathFinder.new(@from, @to, $map).search
  end
end
