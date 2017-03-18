
# Maybe change the night smoothly with minutes instead of discretely by hours?
class DayAndNightCycle
  def initialize
    @time = Time.new(1, 1, 1, 12, 0) # start at 12:00 of the first day ever in history
    @text = Text.new(820, 12, "12:00", 40, "fonts/arial.ttf")
    @sun_shining_mask = Rectangle.new(0, 0, WIDTH, HEIGHT, sun_mask_color)
  end

  def time
    @time.strftime("%H:%M")
  end

  # Nice blue-ish night sky color
  def sun_mask_color
    [0, 33.0 / 255, 115.0 / 255, sun_mask_opacity]
  end

  # Map in such way that at noon is minimum
  # At midnight is maximum
  def sun_mask_opacity
    time_to_sinus_argument = (@time.hour - 6) * 3.14 / 12.0 + 3.14 / 2
    [0, Math.cos(time_to_sinus_argument)].max * 0.20
  end

  # implicitly assume 1 tick means n seconds
  def update
    n = 15
    @time += n * $game_speed.value

    @text.remove
    @text.text = time
    @text.add

    @sun_shining_mask.remove
    @sun_shining_mask.color = sun_mask_color
    @sun_shining_mask.add
  end
end
