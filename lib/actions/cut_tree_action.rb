class CutTreeAction
  HIT_EVERY_TICKS = 40
  NUMBER_OF_HITS  = 6
  ANIMATION_TIME  = 10

  def initialize(tree, parent)
    @tree = tree

    @ticks_left_to_hit   = HIT_EVERY_TICKS
    @hits_left           = NUMBER_OF_HITS
    @animation_time_left = 0

    x = tree.x * PIXELS_PER_SQUARE
    y = tree.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
    @mask.remove
    @parent = parent
  end

  def update
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
      @mask.remove
      @parent.finish
      @tree.remove
      $map[@tree.x, @tree.y] = LogsPile.new(@tree.x, @tree.y)
    end
  end
end
