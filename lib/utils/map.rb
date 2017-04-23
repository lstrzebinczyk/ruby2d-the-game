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

  def []=(x, y, item)
    item.x = x
    item.y = y
    @grid[x, y] = item
    item.render
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

  def find_closest_to(spot, &block)
    @grid.find_all(&block).sort do |a, b|
      distance_a = (spot.x - a.x) ** 2 + (spot.y - a.y) ** 2
      distance_b = (spot.x - b.x) ** 2 + (spot.y - b.y) ** 2

      distance_a - distance_b
    end.first
  end

  def find_free_spot_near(position)
    search_path(position.x, position.y).find do |pos|
      passable?(pos.x, pos.y) and $flood_map.available?(pos.x, pos.y) and in_map?(pos.x, pos.y)
    end
  end

  def free_spots_near(position, count = 1)
    search_path(position.x, position.y).find_all do |pos|
      self[pos.x, pos.y].nil? and $characters_list.none?{|c| c.x == pos.x && c.y == pos.y} and $flood_map.available?(pos.x, pos.y) and in_map?(pos.x, pos.y)
    end.take(count)
  end

  def find_empty_spot_near(position)
    search_path(position.x, position.y).find do |pos|
      self[pos.x, pos.y].nil? and $characters_list.none?{|c| c.x == pos.x && c.y == pos.y} and $flood_map.available?(pos.x, pos.y) and in_map?(pos.x, pos.y)
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
    @grid[x, y] = nil
    $flood_map && $flood_map.set_as_available(x, y)
    nil
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
end
