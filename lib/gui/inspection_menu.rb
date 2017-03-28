class InspectionMenu
  def initialize(width, height, x)
    @width  = width
    @height = height
    @x      = x

    @background = Rectangle.new(@x, 0, @width, @height, "brown")

    @characters = nil
  end

  def characters=(characters_list)
    @characters = characters_list
    render_characters
  end

  # TODO: MAKE THAT WORK PROPERLY WHEN THERE IS >1 CHARACTER
  def render_characters
    @characters.each do |character|
      @char_portrait_x = @x + 10
      @char_portrait_y = 10
      @char_image  = Image.new(@char_portrait_x, @char_portrait_y, character.image_path)
      @char_name   = Text.new(@char_portrait_x + 25, @char_portrait_y, character.name, 16, "fonts/arial.ttf")
      @food_text   = Text.new(@char_portrait_x, @char_portrait_y + 25, "food:", 16, "fonts/arial.ttf")
      @sleep_text  = Text.new(@char_portrait_x, @char_portrait_y + 50, "sleep:", 16, "fonts/arial.ttf")

      @food_progress_bar_background = Rectangle.new(@char_portrait_x + 45, @char_portrait_y + 25, 120, 20, "black")
      @sleep_progress_bar_background = Rectangle.new(@char_portrait_x + 45, @char_portrait_y + 50, 120, 20, "black")
    end

    rerender_progress_bars
  end

  # TODO HAVE THE PROGRESS BAR COLOR DEPEND ON AMOUNT
  # GREEN => GOOD
  # RED   => BAD
  def rerender_progress_bars
    @characters.each do |character|
      @food_progress_bar && @food_progress_bar.remove
      @sleep_progress_bar && @sleep_progress_bar.remove

      food_width_base = 120 - 6
      food_width = food_width_base * character.hunger

      sleep_width_base = 120 - 6
      sleep_width = sleep_width_base * character.energy

      @food_progress_bar = Rectangle.new(@char_portrait_x + 45 + 3, @char_portrait_y + 25 + 3, food_width, 20 - 6, "red")
      @sleep_progress_bar = Rectangle.new(@char_portrait_x + 45 + 3, @char_portrait_y + 50  + 3, sleep_width, 20 - 6, "red")
    end
  end

  def rerender
    @background.remove 
    @background.add 

    @char_image.remove 
    @char_image = nil 

    @char_name.remove 
    @char_name = nil 

    render_characters
  end
end
