class MoveAction
  def initialize(from, to, parent)
    @from       = from
    @to         = to
    @parent     = parent
    @path       = calculate_path
    @ticks_left = 4
  end

  def then
    @next_action = yield
    self
  end

  def update
    @ticks_left -= 1
    if @ticks_left == 0
      @ticks_left = 4
      next_step = @path.shift_node
      if next_step
        @parent.update_position(next_step.x, next_step.y)
      else
        end_action
      end
    end

    if @from.x == @to.x and @from.y == @to.y
      end_action
    end
  end

  def close
    @path.remove
  end

  private

  def end_action
    if @next_action
      @parent.action = @next_action
    else
      @parent.finish
    end
  end

  def calculate_path
    PathFinder.new(@from, @to, $map).search
  end
end
