class ConstructWall
  def initialize
    # super()
    @structure_class        = Wall
    @size                   = 1
  end

  # def initialize
  #   @mouse_background_drawer = MouseBackgroundDrawer.new
  #   @mouse_background_drawer.remove
  # end

  def mouse_down(x, y)
    in_game_x = x / PIXELS_PER_SQUARE
    in_game_y = y / PIXELS_PER_SQUARE
    perform(in_game_x, in_game_y)
    $characters_list.find_all{|char| char.job.is_a? ChillJob}.each(&:finish)
  end

  def mouse_up(x, y)
  end

  def click(x, y)
    mouse_down(x, y)
  end

  def perform(x, y)
  end

  def abort
  end

  def perform(in_game_x, in_game_y)
    if terrain_clear?(in_game_x, in_game_y)
      $structures << Wall::Blueprint.new(in_game_x, in_game_y)
      @mask = nil
    end
  end

  def unhover
    @mask && @mask.remove
  end

  def hover(x, y)
    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE)
    if terrain_clear?(x, y)
      @mask.color = "brown"
    else
      @mask.color = "red"
    end
    @mask.color.opacity = 0.6
  end

  def terrain_clear?(x, y)
    fields = (x..(x+@size-1)).to_a.product((y..(y+@size-1)).to_a)

    fields.all? do |arr|
      GameWorld.things_at(arr[0], arr[1]).empty?
    end
  end
end
