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
      !self[x, y].respond_to?(:impassable?) or !self[x, y].impassable?
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
    item.x = x
    item.y = y
    self[x, y] = item
    item.render
  end

  def find_closest_to(spot, &block)
    @grid.find_all(&block).sort do |a, b|
      distance_a = (spot.x - a.x) ** 2 + (spot.y - a.y) ** 2
      distance_b = (spot.x - b.x) ** 2 + (spot.y - b.y) ** 2

      distance_a - distance_b
    end.first
  end

  def find_free_spot_near(position)
    search_path(position.x, position.y).find do |pos|
      passable?(pos.x, pos.y) and $flood_map.available?(pos.x, pos.y)
    end
  end

  def free_spots_near(position, count = 1)
    search_path(position.x, position.y).find_all do |pos|
      self[pos.x, pos.y].nil? and $characters_list.none?{|c| c.x == pos.x && c.y == pos.y} and $flood_map.available?(pos.x, pos.y)
    end.take(count)
  end

  def find_empty_spot_near(position)
    search_path(position.x, position.y).find do |pos|
      self[pos.x, pos.y].nil? and $characters_list.none?{|c| c.x == pos.x && c.y == pos.y} and $flood_map.available?(pos.x, pos.y)
    end
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
    $flood_map && $flood_map.set_as_available(x, y)
    nil
  end

  # TODO: This should really be moved to some sort of MapCreator.new
  def fill_grid_with_objects
    fill_river
    fill_trees_and_bushes
  end

  private

  DIRECTIONS = [
    [ 1,  0],
    [ 0,  1],
    [-1,  0],
    [ 0, -1]
  ]

  def square_edge_coordinates(center_x, center_y, radius)
    position = [center_x - radius/2, center_y - radius/2]

    DIRECTIONS.lazy
      .flat_map do |direction|
        [direction].lazy
          .cycle
          .take(radius.pred)
      end
      .map do |step|
        old_position = position
        position = position.zip(step).map(&:sum) # elementwise vector sum
        Position.new(old_position[0], old_position[1])
      end
  end

  def odd_numbers
    (0...Float::INFINITY)
      .lazy
      .map { |x| 1 + 2 * x }
  end

  def search_path(x, y)
    odd_numbers
      .drop(1)
      .flat_map { |radius| square_edge_coordinates(x, y, radius) }
  end




  # MAP GENERATION
  # TODO: MOVE TO SEPARATE CLASS

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
    river_sinus_adder(x) + river_sinus_multiplier * Math.sin(river_in_sinus_alpha(x))
  end

  def river_sinus_adder(x)
    @adder_rand ||= rand + rand + rand
    x * 0.07 + @adder_rand
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

    @noise_cache = nil
  end

  def noise_generator
    @noise ||= RandomNoiseGenerator.new
  end

  def set_tree?(x, y)
    rand < get_noise(x, y)
  end

  def set_bush?(x, y) # of love
    rand < (get_noise(x, y) / 2)
  end

  def get_noise(x, y)
    noise_cache[x] ||= {}
    noise_cache[x][y] ||= noise_generator.get(x, y)
    noise_cache[x][y]
  end

  def noise_cache
    @noise_cache ||= {}
  end
end
