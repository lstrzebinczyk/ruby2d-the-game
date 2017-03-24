class Character
  Point = Struct.new(:x, :y)

  def initialize(x, y)
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
    @action = nil
  end

  def has_action?
    !!@action
  end

  def carry=(item)
    @carried_item = item 
  end

  # poor mans implementation of the fact, that carrying big piece of wood makes you slower
  # Exactly 3 times slower, in here
  def speed_multiplier
    if @carried_item and @carried_item.is_a?(Log)
      3
    else
      1
    end
  end

  def get_item
    item = @carried_item
    @carried_item = nil
    item
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

  def action=(action)
    @action && @action.close
    @action = action
  end

  def finish
    @action = nil
  end
end
