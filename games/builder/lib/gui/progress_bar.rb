class ProgressBar
  def initialize(opts = {})
    @x      = opts[:x]      || 0
    @y      = opts[:y]      || 0
    @z      = opts[:z]      || 0
    @width  = opts[:width]  || 100
    @height = opts[:height] || 20
    @border = opts[:border] || 2

    @background_color = opts[:background_color] || "black"
    @color            = opts[:color]            || "red"

    @total    = opts[:total]    || 100
    @progress = opts[:progress] || 0

    @background = Rectangle.new(
      @x,
      @y,
      @width,
      @height,
      @background_color,
      @z
    )

    @progress_mark = Rectangle.new(
      @x + @border,
      @y + @border,
      (@progress / @total) * (@width - 2 * @border),
      @height - 2 * @border,
      @color,
      @z + 0.01
    )
  end

  def increment(amount)
    @progress += amount.to_f
    @progress_mark.width = (@progress / @total) * (@width - 2 * @border)
  end

  def progress=(progress)
    @progress = progress.to_f
    @progress_mark.width = (@progress / @total) * (@width - 2 * @border)
  end

  def remove
    @background.remove
    @progress_mark.remove
  end
end
