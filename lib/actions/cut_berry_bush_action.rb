class CutBerryBushAction < Action::Base
  HIT_EVERY_TICKS = 30
  NUMBER_OF_HITS  = 4
  ANIMATION_TIME  = 8

  def initialize(berry_bush, parent)
    @berry_bush = berry_bush

    @ticks_left_to_hit   = HIT_EVERY_TICKS
    @hits_left           = NUMBER_OF_HITS
    @animation_time_left = 0

    x = berry_bush.x * PIXELS_PER_SQUARE
    y = berry_bush.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
    @mask.remove
    @parent = parent
  end

  def job=(job)
    @job = job
  end

  def update(seconds)
    @ticks_left_to_hit -= 1

    if @ticks_left_to_hit == 0
      @hits_left -= 1
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

    if @hits_left == 0
      finish
    end
  end

  def finish
    @mask.remove
    @parent.finish
    @berry_bush.remove
    @job.remove
  end
end
