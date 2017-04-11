class GatherJob
  def initialize(target)
    @target = target
    x = target.x * PIXELS_PER_SQUARE
    y = target.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
  end

  def type
    :gathering
  end

  def available?
    true
    # $flood_map.available?(@target.x, @target.y)
  end

  def target
    @target
  end

  def action_for(character)
    MoveAction.new(character: character, near: @target)
    # MoveAction.new(character: character, near: @tree).then do
    #   CutTreeAction.new(@tree, character)
    # end
  end

  def remove
    @mask.remove
  end
end
