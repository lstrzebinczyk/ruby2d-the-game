class InspectionMenu
  class CharsTab
    class CharacterWindow
      def initialize(character, y_offset, x)
        @character = character
        @y_offset  = y_offset
        @x = x

        @char_portrait_x = @x
        @char_portrait_y = @y_offset
        @char_image  = Image.new(
          @char_portrait_x,
          @char_portrait_y,
          @character.image_path,
          ZIndex::MENU_BUTTON
        )
        @char_name   = Text.new(@char_portrait_x + 25, @char_portrait_y, @character.name, 16, "fonts/arial.ttf", "white", ZIndex::MENU_BUTTON)
        @food_text   = Text.new(@char_portrait_x, @char_portrait_y + 25, "food:", 16, "fonts/arial.ttf", "white", ZIndex::MENU_BUTTON)
        @sleep_text  = Text.new(@char_portrait_x, @char_portrait_y + 50, "sleep:", 16, "fonts/arial.ttf", "white", ZIndex::MENU_BUTTON)

        @food_progress_bar = ProgressBar.new({
          x: @char_portrait_x + 45,
          y: @char_portrait_y + 25,
          width: 120,
          z: ZIndex::MENU_BUTTON,
          progress: @character.hunger * 100
        })

        @sleep_progress_bar = ProgressBar.new({
          x: @char_portrait_x + 45,
          y: @char_portrait_y + 50,
          width: 120,
          z: ZIndex::MENU_BUTTON,
          progress: @character.energy * 100
        })
      end

      # TODO: Don't be so clever and remove them by hand
      def remove
        instance_variables.map{|v| instance_variable_get(v) }
                          .keep_if{|v| v.respond_to? :remove }
                          .each(&:remove)
      end

      def rerender
        @food_progress_bar.progress  = @character.hunger * 100
        @sleep_progress_bar.progress = @character.energy * 100
      end
    end
    attr_writer :characters

    def initialize(opts)
      @x                       = opts[:x]
      @margin_top              = opts[:margin_top]
      @single_character_height = 80
      @characters              = $characters_list
      @character_windows       = []
    end

    def render
      @characters.each_with_index do |character, index|
        y_position = @margin_top + index * @single_character_height
        @character_windows << CharacterWindow.new(character, y_position, @x + 10)
      end

      rerender
    end

    def remove
      @character_windows.each(&:remove)
    end

    def rerender
      @character_windows.each(&:rerender)
    end
  end

  class InspectTab
    attr_reader :content

    def initialize(opts)
      @x          = opts[:x]
      @margin_top = opts[:margin_top]
      @texts = []
      @content = []
    end

    def content=(content)
      @content = content
      remove
      render
    end

    def render
      @texts.each(&:remove)
      @texts = []

      @content.each_with_index do |c, index|
        x = @x + 5
        y = 30 + 25 * index

        if defined?(c.class::Inspection)
          @texts << c.class::Inspection.new(c, x: x, y: y)
        else
          msg = c.class
          t = Text.new(x, y, msg, 16, "fonts/arial.ttf", "white", ZIndex::MENU_BUTTON_TEXT)
          @texts << t
        end
      end
    end

    def rerender
      remove
      render
    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_accessor :active_tab
  attr_reader :x, :tab_margin_top

  def initialize(width, height, x)
    @width          = width
    @height         = height
    @x              = x
    @tab_margin_top = 40
    @tab_buttons    = []
    @active_tab     = nil

    @background     = Rectangle.new(@x, 0, @width, @height, "brown", ZIndex::MENU_BACKGROUND)
    render_tabs

    @tab_buttons.first.on_click.call
  end

  def content=(content)
    @active_tab.content = content
  end

  def click(x, y)
    @tab_buttons.each do |button|
      if button.contains?(x, y)
        button.on_click.call
      end
    end
  end

  def deactivate_all_buttons
    @tab_buttons.each do |button|
      button.active = false
    end
  end

  def contains?(mouse_x, mouse_y)
    mouse_x > @x
  end

  def render_tabs
    render_button("Chars")
    render_button("Inspect")
  end

  def render_button(text, opts = {})
    opts[:active] = @tab_buttons.none?
    opts[:text_size] = 14
    opts[:active_color] = [1, 1, 1, 0.3]
    opts[:inactive_color] = "brown"

    button = Button.new(text, opts)
    left = if @tab_buttons.any?
      @tab_buttons.last.right + 3
    else
      @x + 3
    end
    button.render(left, 0)
    inspection_menu = self

    button.on_click = -> {
      inspection_menu.set_mode(text)
    }

    @tab_buttons << button
  end

  def set_mode(mode)
    deactivate_all_buttons
    @active_tab.remove if @active_tab
    tab_class_name = "InspectionMenu::" + mode.to_s.tr(" ", "_").camelize + "Tab"
    tab_class = tab_class_name.constantize
    @active_tab = tab_class.new(
      x: x,
      margin_top: tab_margin_top
    )
    @active_tab.render
    @tab_buttons.find{|b| b.text.casecmp(mode.to_s) == 0 }.active = true
  end

  def rerender_content
    @active_tab.rerender
  end
end
