class Creature
  attr_reader :job, :x, :y
  MAX_CALORIES = 3000

  def action=(action)
    @action = action
    @action.start
    nil
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

  def finish
    @action = nil
    @job && @job.remove

    @job = nil
  end

  def job=(job)
    @job = job
    if @job
      @job.start if @job.respond_to?(:start)
      self.action = job.action_for(self)
    end
    $idlers_count.recalculate!
  end

  def has_action?
    !!@action
  end

  def update_position(x, y)
    if ((self.x - x).abs > 1) or ((self.y - y).abs > 1)
      raise ArgumentError, "Teleporting is not allowed! #{self.class} #{self.name} tried to get from (#{self.x}, #{self.y}) to (#{x}, #{y})"
    end

    @x = x
    @y = y

    @image.x = x
    @image.y = y
  end

  def update(seconds)
    update_energy(seconds)
    update_calories(seconds)

    @action && @action.update(seconds)
  end

  private

  def hungry?
    @calories < MAX_CALORIES * 0.5
  end

  def sleepy?
    @energy < 0.15 and $day_and_night_cycle.time.night?
  end

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
end
