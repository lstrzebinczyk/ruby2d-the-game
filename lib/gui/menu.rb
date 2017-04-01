class Menu
  attr_accessor :game_mode

  def initialize
    @game_mode    = CutGameMode.new
    @menu_y_start = WORLD_HEIGHT
    @buttons      = []

    render
  end

  def click(x, y)
    @buttons.each do |button|
      if button.contains?(x, y)
        button.on_click.call
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
    render_button("Inspect",       width: 130)
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

  def set_game_mode(game_mode_name)
    game_mode_class_name = game_mode_name.to_s.gsub(" ", "_").camelize + "GameMode"
    game_mode_class      = game_mode_class_name.constantize

    self.game_mode = game_mode_class.new 
    self.deactivate_all_buttons
    @buttons.find{|b| b.text.downcase == game_mode_name.to_s.downcase }.active = true
  end

  private

  def render_button(text, opts)
    opts[:active] = @buttons.none?

    button = Button.new(text, opts)
    left = if @buttons.any?
      @buttons.last.right + PIXELS_PER_SQUARE
    else
      PIXELS_PER_SQUARE
    end
    button.render(left, @menu_y_start + PIXELS_PER_SQUARE)
    menu = self

    button.on_click = -> {
      menu.set_game_mode(text)
    }

    @buttons << button
  end

  def render_menu_background
    @menu_background = Rectangle.new(0, @menu_y_start, WIDTH, height, "black")
  end
end
