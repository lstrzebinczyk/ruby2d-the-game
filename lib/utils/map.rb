class Map
  class Position
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end
  end

  def initialize(opts)
    @width  = opts[:width]
    @height = opts[:height]
    @grid   = Grid.new

    fill_grid_with_trees
  end

  def [](x, y)
    @grid[x, y]
  end

  def []=(x, y, value)
    @grid[x, y] = value
  end

  def passable?(x, y)
    if @grid[x, y]
      @grid[x, y].passable?
    else
      true
    end
  end

  def put_item(x, y, item)
    if item.is_a? LogsPile::Log
      if self[x, y].is_a? LogsPile
        self[x, y].put(item)
      else
        self[x, y] = LogsPile.new(x, y, 1)
      end
    else
      raise "You need to handle this better"
    end
  end

  # TODO: IMPLEMENT BETTER FREE SPOT POSITION FINDING ALGORITHM
  def find_free_spot_near(position)
    positions = []
    positions << Position.new(position.x - 1, position.y - 1)
    positions << Position.new(position.x - 1, position.y    )
    positions << Position.new(position.x - 1, position.y + 1)
    positions << Position.new(position.x    , position.y - 1)
    # Position.new(position.x    , position.y    )
    positions << Position.new(position.x    , position.y + 1)
    positions << Position.new(position.x + 1, position.y - 1)
    positions << Position.new(position.x + 1, position.y    )
    positions << Position.new(position.x + 1, position.y + 1)
    positions.find_all do |pos|
      passable?(pos.x, pos.y)
    end.first
  end

  def rerender
    @grid.each do |elem|
      elem && elem.rerender
    end
  end

  def clear(x, y)
    elem = self[x, y]
    elem && elem.remove
    self[x, y] = nil
  end

  private

  def set_tree?
    rand < 0.20
  end

  def fill_grid_with_trees
    (0..@width).each do |x|
      (0..@height).each do |y|
        if set_tree?
          @grid[x, y] = Tree.new(x, y)
        end
      end
    end
  end
end
