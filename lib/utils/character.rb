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

  # TODO
  # We want to do

  # action.then do
  #   second_action
  # end.then do
  #   third_action
  # end

  # and have them being executed serially
  def cut_tree(tree)
    target_position = $map.find_free_spot_near(tree)

    @action = move_to_action(target_position.x, target_position.y).then do
      CutTreeAction.new(tree, self)
    end
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
