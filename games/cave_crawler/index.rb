require "pathname"

engine_path = Pathname.new("./../../").realpath.to_s
$LOAD_PATH.unshift(engine_path)

require "engine/grid"

require "ruby2d"

require "pry"

MAP_WIDTH = 60
MAP_HEIGHT = 40

ENTRY_POINT_X = rand(MAP_WIDTH)
ENTRY_POINT_Y = MAP_HEIGHT - 1

PIXELS_PER_SQUARE = 12

set({
  title: "The Cave Crawler",
  width: MAP_WIDTH * PIXELS_PER_SQUARE,
  height: MAP_HEIGHT * PIXELS_PER_SQUARE,
  # diagnostics: true
})

class MapPoint
  attr_reader :filled

  def initialize(x, y, parent)
    @x, @y = x, y
    @filled = true
    @parent = parent
    @mask = Square.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      PIXELS_PER_SQUARE,
      "brown"
    )
  end

  def empty
    @filled = false
    @mask.color = "gray"
  end

  def activate!
    @mask.color = "red"
  end

  def deactivate!
    if @filled
      @mask.color = "brown"
    else
      @mask.color = "gray"
    end
  end

  def random_neighbor
    [
      @parent[@x-1, @y],
      @parent[@x+1, @y],
      @parent[@x, @y+1],
      @parent[@x, @y-1]
    ].compact.sample
  end
end

$grid = Grid.new

MAP_WIDTH.times do |x|
  MAP_HEIGHT.times do |y|
    $grid[x, y] = MapPoint.new(x, y, $grid)
  end
end

# binding.pry

active_map_point = $grid[ENTRY_POINT_X, ENTRY_POINT_Y]

active_map_point.activate!
active_map_point.empty

GENERATE_FLOORS = (MAP_WIDTH * MAP_HEIGHT * 0.3).to_i

$generated_floors = 1

while  $generated_floors < GENERATE_FLOORS
  active_map_point.deactivate!
  active_map_point = active_map_point.random_neighbor
  active_map_point.activate!
  if active_map_point.filled
    active_map_point.empty
    $generated_floors += 1
  end
end


show
