# Maybe change the night smoothly with minutes instead of discretely by hours?
class DayAndNightCycle
  attr_reader :time

  def initialize(height, width)
    @time = Time.new(1, 1, 1, 12, 0) # start at 12:00 of the first day ever in history
    @text = Text.new(820, 12, "12:00", 40, "fonts/arial.ttf")
    @sun_shining_mask = Rectangle.new(0, 0, width, height, [0, 33.0 / 255, 115.0 / 255, 1])
    @old_hour = @time.hour

    @ticks_to_update_clock = (60 / $seconds_per_tick).to_i
  end

  def rerender
    @text.remove
    @text.add
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

    # unless to_s == @text.text
    # end

    if !@time.day? and @old_hour != @time.hour
      @sun_shining_mask.remove
      @sun_shining_mask.color.opacity = sun_mask_opacity
      @sun_shining_mask.add
      @old_hour = @time.hour
    end
  end
end
