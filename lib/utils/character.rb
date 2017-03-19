class Character
  Point = Struct.new(:x, :y)

  def initialize(x, y)
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
    @action = nil
  end

  def x
    @image.x / PIXELS_PER_SQUARE
  end

  def y
    @image.y / PIXELS_PER_SQUARE
  end

  def update
    @action && @action.update
  end

  def update_position(x, y)
    @image.remove
    @image.x = x * PIXELS_PER_SQUARE
    @image.y = y * PIXELS_PER_SQUARE
    @image.add
  end

  def rerender
    @image.remove
    @image.add
  end

  def move_to(in_game_x, in_game_y)
    @action && @action.close
    @action = move_to_action(in_game_x, in_game_y)
  end

  def action=(action)
    @action = action
  end

  def cut_tree(tree)
    target_position = $map.find_free_spot_near(tree)

    move_to_action  = move_to_action(target_position.x, target_position.y)
    cut_tree_action = CutTreeAction.new(tree, self)
    move_to_action.next = cut_tree_action

    @action = move_to_action

    # move_to(target_position.x, target_position.y)
    # Find a spot near that tree and go there with MoveAction
    # Then start cutting the tree
    # puts "will cut tree"
  end

  def finish
    @action = nil
  end

  private

  def move_to_action(x, y)
    target  = Point.new(x, y)
    MoveAction.new(self, target, self)
  end
end
