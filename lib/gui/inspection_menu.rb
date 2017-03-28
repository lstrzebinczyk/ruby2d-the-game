class InspectionMenu
  class CharacterWindow
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
    end

    def rerender
      @food_progress_bar && @food_progress_bar.remove
      @sleep_progress_bar && @sleep_progress_bar.remove

      food_width_base = 120 - 6
      food_width = food_width_base * @character.hunger

      sleep_width_base = 120 - 6
      sleep_width = sleep_width_base * @character.energy

      @food_progress_bar = Rectangle.new(@char_portrait_x + 45 + 3, @char_portrait_y + 25 + 3, food_width, 20 - 6, "red")
      @sleep_progress_bar = Rectangle.new(@char_portrait_x + 45 + 3, @char_portrait_y + 50  + 3, sleep_width, 20 - 6, "red")
    end
  end

  def initialize(width, height, x)
    @width  = width
    @height = height
    @x      = x

    @background = Rectangle.new(@x, 0, @width, @height, "brown")
    @single_character_height = 80

    @characters = nil
    @character_windows = []
  end

  def characters=(characters_list)
    @characters = characters_list
    render_characters
  end

  # TODO: CHARACTER CAN CARRY THE WOOD TO A PLACE THAT MIGHT ALREADY BE FULL

  def render_characters
    @characters.each_with_index do |character, index|
      @character_windows << CharacterWindow.new(character, 10 + index * @single_character_height, @x + 10)
    end

    rerender_progress_bars
  end

  # TODO HAVE THE PROGRESS BAR COLOR DEPEND ON AMOUNT
  # GREEN => GOOD
  # RED   => BAD
  def rerender_progress_bars
    @character_windows.each(&:rerender)
  end

  def rerender
    @background.remove 
    @background.add 

    render_characters
  end
end
