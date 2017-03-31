class Menu
  class Button
    attr_accessor :game_mode
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

  attr_reader :game_mode

  def initialize
    @game_mode    = CutGameMode.new
    @menu_y_start = WORLD_HEIGHT
    @buttons      = []

    render
  end

  def click(x, y)
    @buttons.each do |button|
      if button.contains?(x, y)
        @game_mode = button.game_mode
        deactivate_all_buttons
        button.active = true
      end
    end
  end

  def deactivate_all_buttons
    @buttons.each do |button|
      button.active = false
    end
  end

  def height
    5 * PIXELS_PER_SQUARE
  end

  # those x and y are not in-game x, y
  # they are windows x, y
  # basically for now if y > menus height from bottom, return true
  def contains?(x, y)
    y > @menu_y_start
  end

  def rerender
    @menu_background.remove 
    @menu_background.add 

    @buttons.each do |button|
      button.remove
      button.add
    end
  end

  def render
    render_menu_background

    render_button("Cut",           width: 70 )
    render_button("Do nothing",    width: 190)
    render_button("Set storage",   width: 220)
    render_button("Build kitchen", width: 240)
  end

  def unhover
    @buttons.each do |button|
      if button.hover
        button.hover = false
      end
    end
  end

  def hover(window_x, window_y)
    @buttons.each do |button|
      if button.contains?(window_x, window_y)
        button.hover = true
      end
    end
  end

  private

  def render_button(text, opts)
    game_mode_class_name = text.gsub(" ", "_").camelize + "GameMode"
    game_mode_class      = game_mode_class_name.constantize
    opts[:active] = @buttons.none?

    button = Button.new(text, opts)
    left = if @buttons.any?
      @buttons.last.right + PIXELS_PER_SQUARE
    else
      PIXELS_PER_SQUARE
    end
    button.render(left, @menu_y_start + PIXELS_PER_SQUARE)
    button.game_mode = game_mode_class.new 
    @buttons << button
  end

  def render_menu_background
    @menu_background = Rectangle.new(0, @menu_y_start, WIDTH, height, "black")
  end
end
