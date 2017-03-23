# TODO
# We want to do

# action.then do
#   second_action
# end.then do
#   third_action
# end

# and have them being executed serially

class CutTreeJob
  attr_writer :taken

  def initialize(tree)
    @tree = tree
    x = tree.x * PIXELS_PER_SQUARE
    y = tree.y * PIXELS_PER_SQUARE

    @taken = false
    @finished = false

    @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
  end

  def inspect
    "#<CutTreeJob @y=#{@tree.y}, @x=#{@tree.x}, @taken=#{@taken}, @finished=#{@finished}>"
  end

  def free?
    !@taken
  end

  def target
    @tree
  end

  def action_for(character)
    target_position = $map.find_free_spot_near(@tree)
    MoveAction.new(character, target_position, character).then do
      action = CutTreeAction.new(@tree, character)
      action.job = self
      action
    end
  end

  def remove
    @mask.remove
    @taken    = true

    $job_list.delete(self)
  end
end
