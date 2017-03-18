class MoveAction
  def initialize(from, to, parent)
    @from       = from
    @to         = to
    @parent     = parent
    @path       = calculate_path
    @ticks_left = 4
  end

  def update
    @ticks_left -= $game_speed.value
    if @ticks_left == 0
      @ticks_left = 4
      next_step = @path.shift_node
      @parent.update_position(next_step.x, next_step.y)
    end

    if @from.x == @to.x and @from.y == @to.y
      @parent.finish
    end
  end

  def close
    @path.remove
  end

  private

  def calculate_path
    PathFinder.new(@from, @to, $map).search
  end
end
