class CutTreeJob
  attr_accessor :taken

  def initialize(tree)
    @tree = tree
    x = tree.x * PIXELS_PER_SQUARE
    y = tree.y * PIXELS_PER_SQUARE

    @taken = false

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
  end

  def type
    :woodcutting
  end

  def free?
    !@taken
  end

  def available?
    true
  end

  def target
    @tree
  end

  def action_for(character)
    MoveAction.new(character: character, near: @tree).then do
      action = CutTreeAction.new(@tree, character)
      action.job = self
      action
    end
  end

  def remove
    @mask.remove
    $job_list.delete(self)
  end
end
