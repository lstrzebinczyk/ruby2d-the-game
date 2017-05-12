class Button
  attr_reader :hover, :width, :text, :on_click

  def initialize(text, opts = {})
    @text           = text
    @active         = opts[:active] || false
    @hover          = false
    @text_size      = opts[:text_size] || 36
    @active_color   = opts[:active_color] || [1, 0, 0, 1]
    @inactive_color = opts[:inactive_color] || [0, 0, 1, 1]
    @side_padding   = opts[:side_padding] || 12
    @top_and_bottom_padding = opts[:top_and_bottom_padding] || 4
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
    (x..(x + width)).cover?(mouse_x) && (y..(y + height)).cover?(mouse_y)
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

  def on_click=(on_click)
    @on_click = on_click

    Application.on :mouse_up do |e|
      if self.contains?(e.x, e.y)
        @on_click.call
      end
    end
  end

  def render(x, y)
    @text_element = Text.new(
      x + @side_padding,
      y + @top_and_bottom_padding,
      @text,
      @text_size,
      "fonts/arial.ttf",
      "white",
      ZIndex::MENU_BUTTON_TEXT
    )

    @background = Rectangle.new(
      x,
      y,
      @text_element.width + 2 * @side_padding,
      @text_element.height + 2 * @top_and_bottom_padding,
      color,
      ZIndex::MENU_BUTTON
    )
  end
end
