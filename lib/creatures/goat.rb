class Goat < Creature
  attr_accessor :x, :y
  attr_reader :job

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, image_path)
    @update_stats_every = 10
    @till_update_stats = 0
  end

  def hunger
    0
  end

  def speed
    1
  end

  def action=(action)
    @action = action
    @action.start
    nil
  end

  def finish
    @action = nil
    @job && @job.remove

    @job = nil
  end

  def job=(job)
    @job = job
    if job
      self.action = job.action_for(self)
    end
  end

  def has_action?
    !!@action
  end

  def needs_own_action?
    false
  end

  def chill
    self.job = ChillJob.new(near: self, area: 200)
  end

  # def set_own_action
  # end

  def update(seconds)
    @action && @action.update(seconds)
  end

  def update_position(x, y)
    if ((self.x - x).abs > 1) or ((self.y - y).abs > 1)
      raise ArgumentError, "Teleporting is not allowed! #{self.class} #{self.name} tried to get from (#{self.x}, #{self.y}) to (#{x}, #{y})"
    end

    self.x = x
    self.y = y
    @image.x = x * PIXELS_PER_SQUARE
    @image.y = y * PIXELS_PER_SQUARE
  end

  def energy
    0
  end

  def name
    "Esel"
  end

  def image_path
    "assets/animals/goat.png"
  end

  def rerender
    @image.remove
    @image.add
  end
end
