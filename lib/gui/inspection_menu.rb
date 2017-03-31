class InspectionMenu
  class CharactersTab
    class CharacterWindow
      PROGRESS_BAR_BASE = (120 - 6)
      def initialize(character, y_offset, x)
        @character = character 
        @y_offset  = y_offset
        @x = x

        @char_portrait_x = @x + 10
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

    @background     = Rectangle.new(@x, 0, @width, @height, "brown")
    render_top_menu
    @characters_tab = CharactersTab.new(x: @x, margin_top: @tab_margin_top)
  end

  def characters=(characters_list)
    @characters_tab.characters = characters_list
  end

  def render_top_menu
    @chars_text = Text.new(@x + 10, 6, "Chars", 14, "fonts/arial.ttf")

    @bottom_border = Rectangle.new(@x, 26, @width, 2, [0, 0, 0, 0.3])
    @right_to_chars_button_divider = Rectangle.new(@x + 60, 0, 2, 26, [0, 0, 0, 0.3])
  end

  def rerender_content
    @characters_tab.rerender
  end

  def rerender
    @background.remove
    @background.add

    @chars_text.remove
    @chars_text.add

    @bottom_border.remove
    @bottom_border.add

    @right_to_chars_button_divider.remove
    @right_to_chars_button_divider.add


    @characters_tab.render


    rerender_content
  end
end
