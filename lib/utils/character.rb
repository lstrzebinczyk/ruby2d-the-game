class Character
  Point = Struct.new(:x, :y)

  def initialize(x, y)
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
    @action = nil

    @energy = 0.3 + rand / 2
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

    update_energy
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

  private

  # TODO: when sleeping, have the character sleep always till 6am when rested enough
  # when not rested enough, have a chance of waking up, growing between 6 am and 9am gradually

  # TODO: HAVE QUALITY OF WORK DEPEND ON ENERGY
  #       When person really-really needs to sleep, he works slower
  def update_energy
    # assume that:
    # 8 hours of sleep is enough rest for 16 hours of being awake
    # therefore energy goes from 1 to 0 in 16 hours
    # and goes back when sleeping in 8 hours
    # during one second energy decreases by 1 / (16*60*60) 
    # when sleeping energy increases by 3 times that amount
    # TODO: MAKE REST SPEED DEPEND ON QUALITY OF BED
    @energy -= $seconds_per_tick / 57600.0
    if @energy < 0
      @energy = 0
    end
  end
end

