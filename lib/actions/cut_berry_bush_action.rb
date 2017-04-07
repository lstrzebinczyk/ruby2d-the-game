# I want it to take 20 minutes to cut that tree
# and I want it to hit every 30 ticks

class CutBerryBushAction < Action::Base
  HIT_EVERY_TICKS = 30
  ANIMATION_TIME  = 8

  def initialize(berry_bush, parent)
    @berry_bush = berry_bush

    @ticks_left_to_hit   = HIT_EVERY_TICKS
    @seconds_left = 20.minutes
    @animation_time_left = 0

    x = berry_bush.x * PIXELS_PER_SQUARE
    y = berry_bush.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
    @mask.remove
    @parent = parent
  end

  def update(seconds)
    @seconds_left -= seconds
    @ticks_left_to_hit -= 1

    if @ticks_left_to_hit == 0
      @ticks_left_to_hit = HIT_EVERY_TICKS
      @mask.add
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
    $map.clear(@berry_bush.x, @berry_bush.y)
  end
end
