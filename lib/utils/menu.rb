
class Menu
  class Button
    FONT_SIZE = 36
    def initialize(text, opts = {})
      @text   = text
      @active = opts[:active] || false
      @hover  = false
    end

    def remove
      @text_element.remove 
      @background.remove
    end

    def add
      @background.add 
      @text_element.add
    end

    def contains?(x, y)
      @background.contains?(x, y)
    end

    def width
      FONT_SIZE * @text.length * 0.5
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

    def activate
      @active = true
      @background.color = color
    end

    def deactivate
      @active = false
      @background.color = color
    end

    def hover
      @hover = true
      @background.color = color
    end

    def unhover
      @hover = false
      @background.color = color
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
    @game_mode = CutTreesGameMode.new
    @menu_y_start = HEIGHT - height

    render
  end

  def click(x, y)
    if @cut_trees_button.contains?(x, y)
      @game_mode = CutTreesGameMode.new
      deactivate_all_buttons
      @cut_trees_button.activate
    end

    if @do_nothing_button.contains?(x, y)
      @game_mode = DoNothingGameMode.new
      deactivate_all_buttons
      @do_nothing_button.activate
    end
  end

  def deactivate_all_buttons
    @cut_trees_button.deactivate 
    @do_nothing_button.deactivate
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
    [@menu_background, @cut_trees_button, @do_nothing_button].each do |elem|
      elem.remove
      elem.add
    end
  end

  def render
    render_menu_background
    render_cut_trees_element
    render_nothing_element
  end

  def unhover
    @cut_trees_button.unhover
    @do_nothing_button.unhover
  end

  def hover(window_x, window_y)
    if @cut_trees_button.contains?(window_x, window_y)
      @cut_trees_button.hover
    end

    if @do_nothing_button.contains?(window_x, window_y)
      @do_nothing_button.hover
    end
  end

  private

  def render_cut_trees_element
    @cut_trees_button = Button.new("Cut trees", active: true)
    @cut_trees_button.render(PIXELS_PER_SQUARE, @menu_y_start + PIXELS_PER_SQUARE)
  end

  def render_nothing_element
    @do_nothing_button = Button.new("Do nothing")
    left = 2 * PIXELS_PER_SQUARE + @cut_trees_button.width

    @do_nothing_button.render(left, @menu_y_start + PIXELS_PER_SQUARE)
  end

  def render_menu_background
    @menu_background = Rectangle.new(0, @menu_y_start, WIDTH, height, "black")
  end
end
