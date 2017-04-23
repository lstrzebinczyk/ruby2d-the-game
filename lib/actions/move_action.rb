class MoveAction < Action::Base
  def initialize(opts)
    @character  = opts[:character]
    if !@character.is_a? Creature
      raise ArgumentError, "MoveAction requires :character in input. Received '#{@character.inspect}'"
    end

    @near = opts[:near]
    @to   = opts[:to]

    if @to and @near
      raise ArgumentError, "MoveAction accepts either :to or :near. You passed both"
    end

    if @to.nil?
      # If you are already near that point, congratulations!
      if @near
        if (@near.x - @character.x).abs <= 1 and (@near.y - @character.y).abs <= 1
          @already_there = true
        else
          @to = $map.passable_spots_near(@near).first
        end
      end

    end

    if @to.nil? and @already_there.nil?
      raise ArgumentError, "Shit..."
    end

    @ticks_left = 16 / @character.speed
  end

  def start
    if @already_there
      @path = []
    else
      calculate_path!
    end
  end

  def update(seconds)
    @ticks_left -= 1
    if @ticks_left <= 0
      @ticks_left = 16 / @character.speed
      next_step = @path.shift
      if next_step
        # If the place is free, go there
        # If not, look for new path and use it
        if $map[next_step.x, next_step.y].passable? and $characters_list.none?{|char| char.x == next_step.x and char.y == next_step.y }
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

    if @already_there or (@character.x == @to.x and @character.y == @to.y)
      end_action
    end
  end

  private

  def calculate_path!
    @path = PathFinder.new(@character, @to, $map).search

    if @path.empty?
      puts "Will crash. Tried to get from (#{@character.x}, #{@character.y}) to (#{@to.x}, #{@to.y})"
      raise ArgumentError, "No path: ("
    end
  end
end
