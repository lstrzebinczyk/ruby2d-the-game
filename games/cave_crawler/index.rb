require "pathname"

engine_path = Pathname.new("./../../").realpath.to_s
$LOAD_PATH.unshift(engine_path)

require "engine/grid"

require "ruby2d"

require "pry"

MAP_WIDTH = 30
MAP_HEIGHT = 20

ENTRY_POINT_X = 18
ENTRY_POINT_Y = 19

PIXELS_PER_SQUARE = 12

set({
  title: "The Cave Crawler",
  width: MAP_WIDTH * PIXELS_PER_SQUARE,
  height: MAP_HEIGHT * PIXELS_PER_SQUARE,
  # diagnostics: true
})

class MapPoint
  def initialize(x, y)
    @x, @y = x, y
    @filled = true
    @mask = Square.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      PIXELS_PER_SQUARE,
      "brown"
    )
  end

  def empty
    @filled = true
    @mask.color = "gray"
  end
end

$grid = Grid.new

MAP_WIDTH.times do |x|
  MAP_HEIGHT.times do |y|
    $grid[x, y] = MapPoint.new(x, y)
  end
end

# binding.pry

$grid[ENTRY_POINT_X, ENTRY_POINT_Y].empty

show
