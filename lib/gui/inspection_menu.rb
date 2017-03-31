class InspectionMenu
  class CharactersTab
    class CharacterWindow
      PROGRESS_BAR_BASE = (120 - 6)
      def initialize(character, y_offset, x)
        @character = character 
        @y_offset  = y_offset
        @x = x

        @char_portrait_x = @x
        @char_portrait_y = @y_offset
        @char_image  = Image.new(@char_portrait_x, @char_portrait_y, @character.image_path)
        @char_name   = Text.new(@char_portrait_x + 25, @char_portrait_y, @character.name, 16, "fonts/arial.ttf")
        @food_text   = Text.new(@char_portrait_x, @char_portrait_y + 25, "food:", 16, "fonts/arial.ttf")
        @sleep_text  = Text.new(@char_portrait_x, @char_portrait_y + 50, "sleep:", 16, "fonts/arial.ttf")

        @food_progress_bar_background = Rectangle.new(@char_portrait_x + 45, @char_portrait_y + 25, 120, 20, "black")
        @sleep_progress_bar_background = Rectangle.new(@char_portrait_x + 45, @char_portrait_y + 50, 120, 20, "black")
        @food_progress_bar = Rectangle.new(@char_portrait_x + 45 + 3, @char_portrait_y + 25 + 3, PROGRESS_BAR_BASE, 20 - 6, "red")
        @sleep_progress_bar = Rectangle.new(@char_portrait_x + 45 + 3, @char_portrait_y + 50  + 3, PROGRESS_BAR_BASE, 20 - 6, "red")
      end

      def rerender
        food_width  = PROGRESS_BAR_BASE * @character.hunger
        sleep_width = PROGRESS_BAR_BASE * @character.energy
        @food_progress_bar.width = food_width
        @sleep_progress_bar.width = sleep_width
      end
    end
    attr_writer :characters 

    def initialize(opts)
      @x                       = opts[:x]
      @margin_top              = opts[:margin_top]
      @single_character_height = 80
      @characters              = nil
      @character_windows       = []
    end

    def render
      @characters.each_with_index do |character, index|
        y_position = @margin_top + index * @single_character_height
        @character_windows << CharacterWindow.new(character, y_position, @x + 10)
      end

      rerender
    end

    def rerender
      @character_windows.each(&:rerender)
    end
  end

  def initialize(width, height, x)
    @width          = width
    @height         = height
    @x              = x
    @tab_margin_top = 40
    @tab_buttons    = []

    @background     = Rectangle.new(@x, 0, @width, @height, "brown")
    render_tabs

    @characters_tab = CharactersTab.new(x: @x, margin_top: @tab_margin_top)
  end

  def contains?(mouse_x, mouse_y)
    mouse_x > @x
  end

  def characters=(characters_list)
    @characters_tab.characters = characters_list
  end

  def render_tabs
    render_button("Chars", width: 50)
  end

  def render_button(text, opts)
    # game_mode_class_name = text.gsub(" ", "_").camelize + "GameMode"
    # game_mode_class      = game_mode_class_name.constantize
    opts[:active] = true
    opts[:text_size] = 14
    opts[:active_color] = [1, 1, 1, 0.3]
    opts[:height] = 26

    button = Button.new(text, opts)
    # left = if @buttons.any?
    #   @buttons.last.right + PIXELS_PER_SQUARE
    # else
    #   PIXELS_PER_SQUARE
    # end
    button.render(@x, 0)
    # menu = self

    # button.on_click = -> {
    #   menu.game_mode = game_mode_class.new 
    #   menu.deactivate_all_buttons
    #   button.active = true
    # }

    @tab_buttons << button
  end

  def rerender_content
    @characters_tab.rerender
  end

  def rerender
    @background.remove
    @background.add

    @tab_buttons.each(&:rerender)
    @characters_tab.render

    rerender_content
  end
end
