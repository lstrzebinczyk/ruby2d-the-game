class CutBerryBushJob
  def initialize(berry_bush)
    @berry_bush = berry_bush
    x = berry_bush.x * PIXELS_PER_SQUARE
    y = berry_bush.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
  end

  def type
    :woodcutting
  end

  def available?
    true
  end

  def target
    @berry_bush
  end

  def action_for(character)
    MoveAction.new(character: character, near: @berry_bush).then do
       CutBerryBushAction.new(@berry_bush, character)
    end
  end

  def remove
    @mask.remove
  end
end
