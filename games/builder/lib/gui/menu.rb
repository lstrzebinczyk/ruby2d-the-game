class Menu
  attr_accessor :game_mode

  def initialize
    @menu_y_start = WORLD_HEIGHT
    @buttons      = []

    render

    @buttons.first.on_click.call
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

  def render
    render_menu_background

    # menu first row

    @menu_buttons_top_offset = 0

    render_button("Inspect")
    render_button("Cut")
    render_button("Remove")
    render_button("Set storage",    game_mode: SetZoneGameMode.new(StorageZone))
    render_button("Build workshop", game_mode: BuildGameMode.new(Workshop)     )
    render_button("Build kitchen" , game_mode: BuildGameMode.new(Kitchen)      )
    render_button("Build fishery" , game_mode: BuildGameMode.new(Fishery)      )

    @menu_buttons_top_offset = 38

    render_button("Gather", left: PIXELS_PER_SQUARE)
    render_button("Set pasture", game_mode: SetZoneGameMode.new(PastureZone))
    render_button("Build wall", game_mode: ConstructWallGameMode.new)
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

  def set_game_mode(game_mode)
    self.deactivate_all_buttons
    if game_mode == :inspect
      self.game_mode = InspectGameMode.new
      @buttons.find{|b| b.text == "Inspect" }.active = true
    else
      self.game_mode = game_mode
    end
  end

  private

  def render_button(text, opts = {})
    opts[:active] = @buttons.none?
    opts[:text_size] = 22

    game_mode = if opts[:game_mode]
      opts[:game_mode]
    else
      game_mode_class_name = text.to_s.tr(" ", "_").camelize + "GameMode"
      game_mode_class      = game_mode_class_name.constantize
      game_mode_class.new
    end

    button = Button.new(text, opts)
    left = nil
    if opts[:left]
      left = opts[:left]
    else
      left = if @buttons.any?
        @buttons.last.right + PIXELS_PER_SQUARE
      else
        PIXELS_PER_SQUARE
      end
    end
    button.render(left, @menu_buttons_top_offset + @menu_y_start + PIXELS_PER_SQUARE / 2)
    menu = self

    button.on_click = -> {
      menu.set_game_mode(game_mode)
      button.active = true
    }

    @buttons << button
  end

  def render_menu_background
    @menu_background = Rectangle.new(
      y: @menu_y_start,
      width: WIDTH,
      height: height,
      color: "black",
      z: ZIndex::MENU_BACKGROUND
    )
  end
end
