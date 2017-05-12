class BuildGameMode < GameMode::Base::Point
  def initialize(structure_class, opts = {})
    super()
    @structure_class = structure_class
    @size            = structure_class.size
  end

  def perform(in_game_x, in_game_y)
    if terrain_clear?(in_game_x, in_game_y)
      $structures << Blueprint.new(@structure_class, in_game_x, in_game_y)
      if $menu
        $menu.set_game_mode(:inspect)
      end
      unhover
      @mask = nil
    end
  end

  def unhover
    @mask && @mask.remove
  end

  def hover(x, y)
    @mask = MapRenderer.square(x, y, @size)
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
