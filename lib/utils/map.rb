class Map
  class Position
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end
  end

  attr_reader :width, :height

  include Enumerable

  def initialize(opts)
    @width  = opts[:width]
    @height = opts[:height]
    @grid   = Grid.new
  end

  def each(&block)
    @grid.each(&block)
  end

  def [](x, y)
    @grid[x, y] #|| $characters_list.find{|c| c.x == x && c.y == y}
  end

  def []=(x, y, value)
    @grid[x, y] = value
  end

  def passable?(x, y)
    if self[x, y]
      self[x, y].passable?
    else
      in_map?(x, y)
    end
  end

  def in_map?(x, y)
    0 <= x and x < @width and 0 <= y and y < @height
  end

  def walkable_ground?(x, y)
    in_map?(x, y) and (self[x, y].nil? or !self[x, y].is_a? River)
  end

  def put_item(x, y, item)
    if item.is_a? Log
      if self[x, y].is_a? LogsPile
        self[x, y].put(item)
      elsif self[x, y].nil?
        self[x, y] = LogsPile.new(x, y, 1)
      else
        raise ArgumentError, "you fucked that up"
      end
    elsif item.is_a? Berries
      if self[x, y].is_a? BerriesPile
        self[x, y].put(item)
      elsif self[x, y].nil?
        self[x, y] = BerriesPile.new(x, y, item.grams)
      else
        raise ArgumentError, "you fucked that up"
      end
    else
      raise "You need to handle this better, tried to put #{item}"
    end

    $zones.recalculate
  end

  def find_closest_to(spot, &block)
    @grid.find_all(&block).sort do |a, b|
      distance_a = (spot.x - a.x) ** 2 + (spot.y - a.y) ** 2
      distance_b = (spot.x - b.x) ** 2 + (spot.y - b.y) ** 2

      distance_a - distance_b
    end.first
  end

  # TODO: LET DĘBSKI KNOW!
  # TODO: IMPLEMENT BETTER FREE SPOT POSITION FINDING ALGORITHM
  def find_free_spot_near(position)
    positions = []
    positions << Position.new(position.x - 1, position.y - 1) if passable?(position.x - 1, position.y - 1)
    positions << Position.new(position.x - 1, position.y    ) if passable?(position.x - 1, position.y    )
    positions << Position.new(position.x - 1, position.y + 1) if passable?(position.x - 1, position.y + 1)
    positions << Position.new(position.x    , position.y - 1) if passable?(position.x    , position.y - 1)
    # Position.new(position.x    , position.y    )
    positions << Position.new(position.x    , position.y + 1) if passable?(position.x    , position.y + 1)
    positions << Position.new(position.x + 1, position.y - 1) if passable?(position.x + 1, position.y - 1)
    positions << Position.new(position.x + 1, position.y    ) if passable?(position.x + 1, position.y    )
    positions << Position.new(position.x + 1, position.y + 1) if passable?(position.x + 1, position.y + 1)

    # if positions.none?{|pos| self[pos.x, pos.y].nil? }
    #   require "pry"
    #   binding.pry
    # end

    positions.find do |pos|
      self[pos.x, pos.y].nil?
      # passable?(pos.x, pos.y)
    end#.first
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

  # TODO: This should really be moved to some sort of MapCreator.new
  def fill_grid_with_objects
    fill_river
    fill_trees_and_bushes
  end

  private

  def fill_river
    (0..@width).each do |x|
      (0..@height).each do |y|
        if in_river?(x, y)
          @grid[x, y] = River.new(x, y)
        end
      end
    end
  end

  def in_river?(x, y)
    y > river_sinus(x) and y < river_sinus(x) + 4
    # and y < river_sinus(x) + 4
    # river_sinus(x) < y
  end

  def river_sinus(x)
    river_sinus_adder + river_sinus_multiplier * Math.sin(river_in_sinus_alpha(x))
  end

  def river_sinus_adder
    @adder ||= 1.7 + rand + rand + rand
  end

  def river_sinus_multiplier
    @multiplier ||= 2.3 + 2 * rand + 2 * rand
  end

  def river_in_sinus_alpha(x)
    @tr ||= rand - rand + rand - rand
    @ml ||= 0.1 + rand/10 - rand/10

    @tr + x * @ml
  end

  def fill_trees_and_bushes
    (0..@width).each do |x|
      (0..@height).each do |y|
        if @grid[x, y].nil?
          if set_tree?(x, y)
            @grid[x, y] = Tree.new(x, y)
          elsif set_bush?(x, y)
            @grid[x, y] = BerryBush.new(x, y)
          end
        end
      end
    end
  end

  def noise_generator
    @noise ||= RandomNoiseGenerator.new
  end

  def set_tree?(x, y)
    rand < noise_generator.get(x, y)
  end

  def set_bush?(x, y) # of love
    rand < (noise_generator.get(x, y) / 2)
  end
end
