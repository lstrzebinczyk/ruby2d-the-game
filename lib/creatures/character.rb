# TODO: INTRODUCE CharacterState classess (sleeping, working, slacking etc)
# TODO: INTRODUCE characterType classess (gatherer, lumberjack etc)

class Character < Creature
  class Inspection
    def initialize(character, opts = {})
      msg = "#{character.name}, a #{character.type}"
      x = opts[:x]
      y = opts[:y]
      @t = Text.new(x, y, msg, 16, "fonts/arial.ttf")
      @t1 = Text.new(x, y + 20, "Job: #{character.job.class}", 16, "fonts/arial.ttf")
      @t2 = Text.new(x, y + 40, "Action: #{character.action.class}", 16, "fonts/arial.ttf")
      @t3 = Text.new(x, y + 60, "Carries: #{character.carry.class}", 16, "fonts/arial.ttf")
    end

    def remove
      @t.remove
      @t1.remove
      @t2.remove
      @t3.remove
    end
  end

  attr_accessor :energy, :calories
  attr_reader   :state, :name, :accepts_jobs, :type, :job, :action

  def initialize(opts)
    x     = opts[:x]
    y     = opts[:y]
    @name = opts[:name]
    @type = opts[:type]
    @accepts_jobs = {
      woodcutter: [:woodcutting, :haul],
      gatherer: [:cooking, :milking, :gathering, :haul],
      craftsman: [:building, :carpentry, :haul],
      fisherman: [:fish_cleaning, :fishing, :haul]
    }[@type]

    @image = MapRenderer.image(x, y, image_path, ZIndex::CREATURE)
    @action = nil

    @energy = 0.6 + rand / 3
    @calories = MAX_CALORIES * (0.7 + 0.3 * rand)

    @state  = :working
  end

  def impassable?
    true
  end

  def pickable?
    false
  end

  def hunger
    @calories.to_f / MAX_CALORIES
  end

  def image_path
    "assets/characters/#{@type}.png"
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

  def get_item
    item = @carried_item
    @carried_item = nil
    item
  end

  # TODO: LET CHARACTER ABANDON THEIR TASKS WHEN THEY REALLY NEED TO SLEEP OR EAT OR SOMETHING
  #       AND GET TO IT LATER

  def chill
    fireplace = $structures.find{|s| s.is_a? Fireplace }
    self.job = ChillJob.new(near: fireplace)
  end

  def needs_own_action?
    hungry? || sleepy?
  end

  def set_own_action
    if hungry?
      food_container = $map.spots_near(self).find do |spot|
        spot.content.is_a? Container and spot.content.storage.any?{|ob| ob.category == :food }
      end

      if food_container
        self.job = EatJob.new(from_container: food_container)
        return
      end

      food = $map.spots_near(self).find do |spot|
        spot.content.respond_to?(:category) and spot.content.category == :food
      end

      if food
        self.job = EatJob.new(from: food)
      else
        berries_spot = $map.spots_near(self).find do |spot|
          spot.content.is_a? BerryBush and !spot.content.picked?
        end

        # If there is no stored food anywhere, find any berries spot and gather it
        # from hunger
        if berries_spot
          berries_spot.content.will_get_picked!
          self.job = GatherJob.new(berries_spot)
        end
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
        self.job = SleepJob.new(near: fireplace)
      else
        self.job = SleepJob.new(at: self)
      end
    else
      raise "ERROR"
    end
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
    $structures.any?{|structure| structure.is_a? Fireplace }
  end

  # treat like meters per seconds
  def speed
    4
  end
end

