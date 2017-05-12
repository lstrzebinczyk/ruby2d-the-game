require "pathname"

engine_path = Pathname.new("./../../").realpath.to_s
$LOAD_PATH.unshift(engine_path)

require "engine/grid"

require "ruby2d"

require "pry"

MAP_WIDTH = 60
MAP_HEIGHT = 60

ENTRY_POINT_X = MAP_WIDTH  / 2
ENTRY_POINT_Y = MAP_HEIGHT / 2

PIXELS_PER_SQUARE = 10

set({
  title: "The Cave Crawler",
  width: MAP_WIDTH * PIXELS_PER_SQUARE,
  height: MAP_HEIGHT * PIXELS_PER_SQUARE,
  background: "brown"
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

  def remove
    @mask.remove
  end

  def empty
    @filled = false
    @mask.color = "gray" unless @entry_point
  end

  def set_as_entry_point!
    @entry_point = true
    @mask.color = "blue"
  end

  def activate!
    @mask.color = "red" unless @entry_point
  end

  def deactivate!
    if @entry_point
      @mask.color = "blue"
    elsif @filled
      @mask.color = "brown"
    else
      @mask.color = "gray"
    end
  end

  def random_neighbor
    directions = [
      [@x-1, @y],
      [@x+1, @y],
      [@x, @y+1],
      [@x, @y-1]
    ]
    direction = directions.sample

    neighbor = @parent[direction[0], direction[1]]
    if neighbor
      neighbor
    else
      new_map_point = MapPoint.new(direction[0], direction[1], @parent)
      @parent[direction[0], direction[1]] = new_map_point
      new_map_point
    end
    # [
    # ].compact.sample
  end
end
# binding.pry
def generate_map
  time = Time.now

  grid = Grid.new

  # MAP_WIDTH.times do |x|
  #   MAP_HEIGHT.times do |y|
  #     grid[x, y] = MapPoint.new(x, y, grid)
  #   end
  # end

  active_map_point = MapPoint.new(ENTRY_POINT_X, ENTRY_POINT_Y, grid)

  grid[ENTRY_POINT_X, ENTRY_POINT_Y] = active_map_point
  active_map_point.set_as_entry_point!
  active_map_point.activate!
  active_map_point.empty
  generated_floors = 1

  while generated_floors < GENERATE_FLOORS
    active_map_point.deactivate!
    active_map_point = active_map_point.random_neighbor
    active_map_point.activate!
    if active_map_point.filled
      active_map_point.empty
      generated_floors += 1
    end
  end

  puts "Generation time: #{Time.now - time}"

  grid
end

GENERATE_FLOORS = 500
$grid = generate_map



# while  $generated_floors < GENERATE_FLOORS
#   active_map_point.deactivate!
#   active_map_point = active_map_point.random_neighbor
#   active_map_point.activate!
#   if active_map_point.filled
#     active_map_point.empty
#     $generated_floors += 1
#   end
# end

on :key_down do |e|
  if e.key == "r"
    $grid.each do |map_point|
      map_point.remove
    end

    $grid = generate_map
  end
end


show
