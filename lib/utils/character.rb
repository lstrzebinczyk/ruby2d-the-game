class Character
  attr_accessor :energy  
  attr_reader   :x, :y, :state

  def initialize(x, y)
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
    @action = nil

    @name = "Johann" # Warhammer-style german like setting is awesome
    @energy = 0.3 + rand / 2
    @state  = :working
  end

  def state=(state)
    unless [:working, :sleeping].include?(state)
      raise ArgumentError, "Incorrect character state"
    end

    @state = state

    if state == :sleeping 
      indicator_x = x * PIXELS_PER_SQUARE + 11
      indicator_y = y * PIXELS_PER_SQUARE - 7
      @sleeping_indicator_1 = Text.new(indicator_x, indicator_y, "z", 10, "fonts/arial.ttf")

      indicator_x = x * PIXELS_PER_SQUARE + 16
      indicator_y = y * PIXELS_PER_SQUARE - 16
      @sleeping_indicator_2 = Text.new(indicator_x, indicator_y, "z", 11, "fonts/arial.ttf")
    end

    if state == :working
      @sleeping_indicator_1.remove
      @sleeping_indicator_1 = nil

      @sleeping_indicator_2.remove
      @sleeping_indicator_2 = nil
    end
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

  # TODO: LET CHARACTER ABANDON THEIR TASKS WHEN THEY REALLY NEED TO SLEEP OR EAT OR SOMETHING
  #       AND GET TO IT LATER

  # TODO: CREATE AN INSPECTION MENU
  # TODO: WITH CHARACTERS PROGRESS BARS
  # TODO: SHOWING THEIR ENERGY AND SO ON
  def update(seconds)
    update_energy

    @action && @action.update(seconds)
  end

  def needs_own_action?
    if sleepy?
      # Character will not go to sleep if it's too early
      # And will try to do some more work
      $day_and_night_cycle.time.hour >= 18
    else
      false
    end
  end

  def set_own_action
    if sleepy?
      if has_own_bed?
        # TODO
        # go to sleep to own bed
      elsif dormitory_present?
        # TODO
        # go to sleep to dormitory
      elsif fireplace_present?
        # find a place to sleep near fireplace
        spot = $map.find_free_spot_near($fireplace)
        sleep_action = MoveAction.new(self, spot, self).then do 
          SleepAction.new(self)
        end

        self.action = sleep_action
      else
        # TODO
        # TODO MAKE FIREPLACE BUILDABLE INSTEAD OF HAVING IT FROM BEGINNING
        # TODO MAKE STONES PART OF MAP
        # TODO MAKE FIREPLACE BUILDABLE FROM STONES
        # Go to sleep where you are standing
        raise "NOT IMPLEMENTED"
      end
    else
      raise "ERROR"
    end
  end

  def has_own_bed?
    false
  end

  def dormitory_present?
    false 
  end

  def fireplace_present?
    true
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

    puts "ENERGY: #{@energy}"
  end

  def sleepy?
    @energy < 0.15
  end
end

