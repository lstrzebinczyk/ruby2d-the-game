class Button
  attr_accessor :on_click
  attr_reader :hover, :width

  def initialize(text, opts = {})
    @text           = text
    @active         = opts[:active] || false
    @hover          = false
    @width          = opts[:width]
    @height         = opts[:height] || 3 * PIXELS_PER_SQUARE
    @text_size      = opts[:text_size] || 36
    @active_color   = opts[:active_color]   || [1, 0, 0, 1]
    @inactive_color = opts[:inactive_color]   || [0, 0, 1, 1]
  end

  def remove
    @text_element.remove 
    @background.remove
  end

  def add
    @background.add 
    @text_element.add
  end

  def rerender
    remove
    add
  end

  def contains?(mouse_x, mouse_y)
    x      = @background.x
    y      = @background.y 
    width  = @background.width 
    height = @background.height
    (x..(x + width)).include?(mouse_x) && (y..(y + height)).include?(mouse_y)
  end

  def color
    if @active
      @active_color
    else
      @inactive_color
    end
  end

  def opacity
    if @hover
      0.6
    else
      1
    end
  end

  def active=(active)
    @active = active
    @background.color = color
  end

  def hover=(hover)
    @hover = hover
    @background.color.opacity = opacity
  end

  def right
    @background.x2.to_i
  end

  def render(x, y)
    @background = Rectangle.new(
      x, 
      y, 
      width,
      @height, 
      color
    )

    @text_element = Text.new(
      x + 4, 
      y + 4, 
      @text, @text_size, "fonts/arial.ttf"
    )
  end
end
