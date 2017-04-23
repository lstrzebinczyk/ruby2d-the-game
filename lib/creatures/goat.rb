class Goat < Creature
  attr_reader :state
  attr_accessor :energy, :hunger

  def initialize(x, y)
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, image_path)
    @energy = 0.6 + rand / 3
    @calories = MAX_CALORIES * (0.7 + 0.3 * rand)

    @state  = :working
  end

  def speed
    1
  end

  def needs_own_action?
    sleepy?
  end

  def chill
    self.job = ChillJob.new(near: self, area: 200)
  end

  def set_own_action
    # if hungry?
      # food_container = $map.find_closest_to(self) do |map_object|
      #   map_object.is_a? Container and map_object.storage.any?{|ob| ob.category == :food }
      # end

      # if food_container
      #   self.job = EatJob.new(from_container: food_container)
      #   return
      # end

      # food = $map.find_closest_to(self) do |map_object|
      #   map_object.respond_to?(:category) and map_object.category == :food
      # end

      # if food
      #   self.job = EatJob.new(from: food)
      # else
      #   berries_spot = $map.find_closest_to(self) do |map_object|
      #     map_object.is_a? BerryBush and !map_object.picked? and $flood_map.available?(map_object.x, map_object.y)
      #   end
      #   # If there is no stored food anywhere, find any berries spot and gather it
      #   # from hunger
      #   berries_spot.will_get_picked!
      #   self.job = GatherJob.new(berries_spot)
      # end
    # elsif sleepy?
    if sleepy?
      self.job = SleepJob.new(at: self)
    else
      raise "ERROR"
    end
  end

  def image_path
    "assets/animals/goat.png"
  end
end
