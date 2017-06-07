# Maybe change the night smoothly with minutes instead of discretely by hours?
class DayAndNightCycle
  attr_reader :time

  def initialize(height, width)
    @time = Time.new(1, 1, 1, 12, 0) # start at 12:00 of the first day ever in history
    @text = Text.new(x: 820, y: 12, text: "12:00", size: 40, font: "fonts/arial.ttf", z: ZIndex::GAME_WORLD_TEXT)
    @sun_shining_mask = Rectangle.new(
      width: width,
      height: height,
      color: [0, 33.0 / 255, 115.0 / 255, 0],
      z: ZIndex::NIGHT_MASK
    )
    @old_hour = @time.hour

    @ticks_to_update_clock = (60 / $seconds_per_tick).to_i
  end

  def to_s
    @time.strftime("%H:%M")
  end

  # Map in such way that at noon is minimum
  # At midnight is maximum
  def sun_mask_opacity
    time_to_sinus_argument = (@time.hour - 6) * 3.14 / 12.0 + 3.14 / 2
    Math.cos(time_to_sinus_argument) * 0.225
  end

  # implicitly assume 1 tick means n seconds
  def update
    n = $seconds_per_tick
    @time += n

    @ticks_to_update_clock -= 1

    if @ticks_to_update_clock == 0
      @ticks_to_update_clock = (60 / $seconds_per_tick).to_i
      @text.text = to_s
    end

    if !@time.day? and @old_hour != @time.hour
      @sun_shining_mask.color.opacity = sun_mask_opacity
      @old_hour = @time.hour
    end
  end
end
