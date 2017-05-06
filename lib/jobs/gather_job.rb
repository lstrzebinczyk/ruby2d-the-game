class GatherJob
  def initialize(target)
    @target = target
    x = target.x * PIXELS_PER_SQUARE
    y = target.y * PIXELS_PER_SQUARE

    @mask = Square.new(
      x,
      y,
      PIXELS_PER_SQUARE,
      [1, 0, 0, 0.2],
      ZIndex::MAP_ELEMENT_OVERLAY
    )
  end

  def type
    :gathering
  end

  def available?
    $map[@target.x, @target.y].available
  end

  def target
    @target
  end

  def action_for(character)
    MoveAction.new(character: character, near: @target).then do
      GatherAction.new(character, @target)
    end
  end

  def remove
    @mask.remove
  end
end
