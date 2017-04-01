# TODO: INTRODUCE CharacterState classess (sleeping, working, slacking etc)
# TODO: INTRODUCE characterType classess (gatherer, lumberjack etc)

class Character
  attr_accessor :energy
  attr_reader   :x, :y, :state, :name, :accepts_jobs

  MAX_CALORIES = 3000
  def initialize(opts)
    x     = opts[:x]
    y     = opts[:y]
    @name = opts[:name]
    @type = opts[:type]
    @accepts_jobs = {
      woodcutter: [:woodcutting, :haul],
      gatherer: [:gathering, :haul]
    }[@type]
    
    @image  = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, image_path)
    @action = nil

    @energy = 0.6 + rand / 3
    @calories = MAX_CALORIES * (0.7 + 0.3 * rand)

    @state  = :working
  end

  def passable?
    false
  end

  def can_carry_more?
    false
  end

  def hunger
    @calories.to_f / MAX_CALORIES
  end

  def image_path
    "assets/characters/#{@type}.png"
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

  def carry
    @carried_item
  end

  def carry=(item)
    @carried_item = item 
  end

  def has_something_to_eat?
    @carried_item && @carried_item.is_a?(Berries)
  end

  def eat(seconds)
    @calories += @carried_item.calories_eaten_in(seconds)
    @carried_item = nil if @carried_item.empty?
  end

  # poor mans implementation of the fact, that carrying big piece of wood makes you slower
  # Exactly 6 times slower, in here
  def speed_multiplier
    if @carried_item and @carried_item.is_a?(Log)
      6
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
  def update(seconds)
    update_energy(seconds)
    update_calories(seconds)

    @action && @action.update(seconds)
  end

  def needs_own_action?
    hungry? || sleepy?
  end

  def set_own_action
    if hungry?
      if food_in_storage?
        # TODO fetch food from storage and eat it
      else
        berries_spot = $map.find_closest_to(self) do |map_object|
          map_object.is_a? BerryBush and !map_object.picked?
        end

        to_go_spot = $map.find_free_spot_near(berries_spot)

        # TODO: FOR NOW BERRIES HAVE UNLIMITED AMOUNTS OF BERRIES
        # TODO: HAVE BERRIES BE LIMITED AND REFILLED WITH TIME
        action = MoveAction.new(self, to_go_spot, self).then do
          GatherBerriesAction.new(self, berries_spot)
        end.then do 
          EatAction.new(self)
        end

        self.action = action
      end
    elsif sleepy?
      if has_own_bed?
        # TODO
        # go to sleep to own bed
      elsif dormitory_present?
        # TODO
        # go to sleep to dormitory
      elsif fireplace_present?
        # find a place to sleep near fireplace
        fireplace = $structures.find{|s| s.is_a? Fireplace }
        spot = $map.find_free_spot_near(fireplace)
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

  # TODO: this must be dynamic based on actual facts on map
  def food_in_storage?
    false
  end

  # TODO: this must be dynamic based on actual facts on map
  def has_own_bed?
    false
  end

  # TODO: this must be dynamic based on actual facts on map
  def dormitory_present?
    false 
  end

  # TODO: this must be dynamic based on actual facts on map
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
    @action = action
    @action.start
    nil
  end

  def finish
    @action = nil
  end

  private
  # TODO: HAVE QUALITY OF WORK DEPEND ON ENERGY
  #       When person really-really needs to sleep, he works slower
  def update_energy(seconds)
    # assume that:
    # 8 hours of sleep is enough rest for 16 hours of being awake
    # therefore energy goes from 1 to 0 in 16 hours
    # and goes back when sleeping in 8 hours
    # during one second energy decreases by 1 / (16*60*60) 
    # when sleeping energy increases by 3 times that amount
    # TODO: MAKE REST SPEED DEPEND ON QUALITY OF BED
    @energy -= seconds / 57600.0
    if @energy < 0
      @energy = 0
    end
  end

  def update_calories(seconds)
    @calories -= seconds * calories_loss_per_second
  end

  def calories_loss_per_second
    if state == :sleeping 
      # 69 calories per hour 
      # 69.0 / (60 * 60) per second 
      0.019
    elsif state == :working
      # TODO
      # https://www.fitnessblender.com/blog/calories-burned-by-occupation-how-many-calories-does-my-job-burn
      # 102.5 cal/hour                 | calm work
      # 127.5 calories burned per hour | moderate work
      # 175 calories per hour          | heavy work
      # for now only use moderate work
      # so 127.5 / (60 * 60)
      0.0354
    end
  end

  def sleepy?
    @energy < 0.15 and $day_and_night_cycle.time.night?
  end

  def hungry?
    @calories < MAX_CALORIES * 0.5
  end
end

