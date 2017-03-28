class MoveAction < Action::Base
  def initialize(from, to, character)
    @from       = from
    @to         = to
    @character  = character
    @path       = calculate_path(from: @from)
    @ticks_left = 4 * @character.speed_multiplier
  end
  
  # 4 meters per second when @character.speed_multiplier == 1
  def update(seconds)
    @ticks_left -= 1
    if @ticks_left == 0
      @ticks_left = 4 * @character.speed_multiplier
      next_step = @path.shift
      if next_step
        # If the place is free, go there
        # If not, look for new path and use it
        if $map.passable?(next_step.x, next_step.y)
          @character.update_position(next_step.x, next_step.y)
        else
          # If this was the last step you meant to take
          # Just stop where you are
          if @path.empty?
            end_action
          else
            @path = calculate_path(from: @character)
            next_step = @path.shift
            @character.update_position(next_step.x, next_step.y)
          end
        end
      else
        end_action
      end
    end

    if @from.x == @to.x and @from.y == @to.y
      end_action
    end
  end

  def calculate_path(opts)
    from = opts[:from]
    PathFinder.new(from, @to, $map).search
  end
end
