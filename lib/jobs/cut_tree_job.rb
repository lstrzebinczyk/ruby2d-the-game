class CutTreeJob
  def initialize(tree)
    @tree = tree
    x = tree.x * PIXELS_PER_SQUARE
    y = tree.y * PIXELS_PER_SQUARE

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
  end

  def type
    :woodcutting
  end

  # Job is available if character can get to the tree
  def available?
    true
  end

  def target
    @tree
  end

  def action_for(character)
    MoveAction.new(character: character, near: @tree).then do
      CutTreeAction.new(@tree, character)
    end
  end

  def remove
    @mask.remove
  end
end
