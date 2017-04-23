class Goat < Creature
  attr_reader :state
  attr_accessor :energy, :hunger, :calories

  def initialize(x, y)
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, image_path)
    @energy = 0.6 + rand / 3
    @calories = MAX_CALORIES * (0.7 + 0.3 * rand)

    @state  = :working

    @pasture = nil
  end

  def pasture=(pasture)
    @pasture = pasture
  end

  def speed
    1
  end

  def needs_own_action?
    hungry? || sleepy?
  end

  def chill
    if @pasture
      field_arr = @pasture.self_fields.sample
      map_spot = $map[field_arr[0], field_arr[1]]
      self.job = ChillJob.new(at: map_spot)
    else
      self.job = ChillJob.new(near: self, area: 200)
    end
  end

  def set_own_action
    if hungry?
      self.job = EatGrassJob.new(at: self)
    elsif sleepy?
      self.job = SleepJob.new(at: self)
    else
      raise "ERROR"
    end
  end

  def image_path
    "assets/animals/goat.png"
  end
end
