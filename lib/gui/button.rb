class Button
  attr_accessor :on_click
  attr_reader :hover, :width

  FONT_SIZE = 36
  def initialize(text, opts = {})
    @text   = text
    @active = opts[:active] || false
    @hover  = false
    @width  = opts[:width]
  end

  def remove
    @text_element.remove 
    @background.remove
  end

  def add
    @background.add 
    @text_element.add
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
      [1, 0, 0, opacity]
    else
      [0, 0, 1, opacity]
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
    menu_element_tiles_height = 3
    @background = Rectangle.new(
      x, 
      y, 
      width, # TWEAK IT 
      menu_element_tiles_height * PIXELS_PER_SQUARE, 
      color
    )

    @text_element = Text.new(
      x + 4, 
      y + 4, 
      @text, FONT_SIZE, "fonts/arial.ttf"
    )
  end
end
