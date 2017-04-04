# I want it to take 4 hours to cut that tree
# and I want it to hit every 40 ticks

# TODO: HAVE THE CHARACTER CHANGE PLACE FROM WHISH HE CUTS THE TREE
# TODO: A COUPLE TIMES

class CutTreeAction < Action::Base
  HIT_EVERY_TICKS = 40
  ANIMATION_TIME  = 10

  def initialize(tree, parent)
    @tree = tree

    @ticks_left_to_hit   = HIT_EVERY_TICKS
    @seconds_left = 4.hours
    @animation_time_left = 0

    x = tree.x * PIXELS_PER_SQUARE
    y = tree.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
    @mask.remove
    @parent = parent
  end

  def update(seconds)
    @seconds_left -= seconds
    @ticks_left_to_hit -= 1

    if @ticks_left_to_hit == 0
      @ticks_left_to_hit = HIT_EVERY_TICKS
      # @mask.add
      @animation_time_left = ANIMATION_TIME
    end

    if @animation_time_left > 0
      @animation_time_left -= 1
      if @animation_time_left == 0
        @mask.remove
      end
    end

    if @seconds_left <= 0
      finish
    end
  end

  def finish
    @mask.remove
    @parent.finish
    @tree.remove
    $map[@tree.x, @tree.y] = LogsPile.new(@tree.x, @tree.y)

    $map[@tree.x, @tree.y].count.times do
      new_job = CarryLogJob.new(from: @tree)
      $job_list.add(new_job)
    end
  end
end
