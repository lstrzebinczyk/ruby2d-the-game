class MoveAction < Action::Base
  def initialize(opts)
    @character  = opts[:character]
    if !@character.is_a? Character
      raise ArgumentError, "MoveAction requires :character in input. Received '#{@character.inspect}'"
    end

    @near = opts[:near]
    @to   = opts[:to]

    if @to and @near
      raise ArgumentError, "MoveAction accepts either :to or :near. You passed both"
    end

    if @to.nil?
      @to = $map.find_free_spot_near(@near)
    end

    if @to.nil?
      raise ArgumentError, "Shit..."
    end

    @ticks_left = 4 * @character.speed_multiplier
  end

  def start
    calculate_path!
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
            calculate_path!
            next_step = @path.shift
            @character.update_position(next_step.x, next_step.y)
          end
        end
      else
        end_action
      end
    end

    if @character.x == @to.x and @character.y == @to.y
      end_action
    end
  end

  private

  def calculate_path!
    @path = PathFinder.new(@character, @to, $map).search
    @path.shift # First step in that path is always where @character is

    if @path.empty?
      raise ArgumentError, "No path: ("
    end
  end
end
