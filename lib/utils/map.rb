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

    fill_grid_with_objects
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
    if item.is_a? Log
      if self[x, y].is_a? LogsPile
        self[x, y].put(item)
      else
        self[x, y] = LogsPile.new(x, y, 1)
      end
    else
      raise "You need to handle this better"
    end
  end

  def find_closest_to(spot, &block)
    # require "pry"
    # binding.pry

    @grid.find_all(&block).sort do |a, b|
      distance_a = (spot.x - a.x) ** 2 + (spot.y - a.y) ** 2
      distance_b = (spot.x - b.x) ** 2 + (spot.y - b.y) ** 2

      distance_a - distance_b
    end.first

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

  def noise_generator
    @noise ||= RandomNoiseGenerator.new
  end

  def set_tree?(x, y)
    rand < noise_generator.get(x, y)
  end

  def set_bush?(x, y) # of love
    rand < (noise_generator.get(x, y) / 2)
  end

  def fill_grid_with_objects
    (0..@width).each do |x|
      (0..@height).each do |y|
        if set_tree?(x, y)
          @grid[x, y] = Tree.new(x, y)
        elsif set_bush?(x, y)
          @grid[x, y] = BerryBush.new(x, y)
        end
      end
    end
  end
end
