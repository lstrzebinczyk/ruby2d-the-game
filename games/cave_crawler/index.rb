require "pathname"

engine_path = Pathname.new("./../../").realpath.to_s
$LOAD_PATH.unshift(engine_path)

require "engine/grid"
require "engine/path_finder"

require "ruby2d"

require "pry"

MAP_WIDTH = 40
MAP_HEIGHT = 40

ENTRY_POINT_X = MAP_WIDTH  / 2
ENTRY_POINT_Y = MAP_HEIGHT / 2

PIXELS_PER_SQUARE = 16

set({
  title: "The Cave Crawler",
  width: MAP_WIDTH * PIXELS_PER_SQUARE,
  height: MAP_HEIGHT * PIXELS_PER_SQUARE,
  background: "brown"
  # diagnostics: true
})

class MapPoint
  attr_reader :filled, :x, :y, :outro_point

  def initialize(x, y, parent)
    @x, @y = x, y
    @x_offset = 0
    @y_offset = 0
    @filled = true
    @parent = parent
    @mask = Square.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      PIXELS_PER_SQUARE,
      "brown"
    )
  end

  def x_offset=(x_offset)
    @x_offset = x_offset
    @mask.x = (@x + @x_offset) * PIXELS_PER_SQUARE
  end

  def y_offset=(y_offset)
    @y_offset = y_offset
    @mask.y = (@y + @y_offset) * PIXELS_PER_SQUARE
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

  def set_as_outro_point!
    @outro_point = true
    @mask.color = "fuchsia"
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
  end
end

def generate_map
  time = Time.now

  grid = Grid.new

  active_map_point = MapPoint.new(ENTRY_POINT_X, ENTRY_POINT_Y, grid)
  entry_point = active_map_point


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

  outro_point = grid.sort_by do |a|
    (a.x - entry_point.x).abs + (a.y - entry_point.y).abs
  end.last

  outro_point.set_as_outro_point!

  puts "Generation time: #{Time.now - time}"

  grid
end

GENERATE_FLOORS = 2000
$grid = generate_map

$x_offset = 0
$y_offset = 0

class Character
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Image.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      "assets/character.png"
    )
  end

  def remove
    @image.remove
  end

  def x=(x)
    @x = x
    $x_offset = ENTRY_POINT_X - @x
    $grid.each do |elem|
      elem.x_offset = $x_offset
    end
  end

  def y=(y)
    @y = y
    $y_offset = ENTRY_POINT_Y - @y

    $grid.each do |elem|
      elem.y_offset = $y_offset
    end
  end
end

$character = Character.new(ENTRY_POINT_X, ENTRY_POINT_Y)

on :key_down do |e|
  if e.key == "r"
    $grid.each do |map_point|
      map_point.remove
    end

    $grid = generate_map
  end
end

# $move_counter = 0

# on :key_held do |e|
#   $move_counter += 1
#   if $move_counter == 3
#     $move_counter = 0
#     if e.key == "w"
#       $character.y -= 1 if $grid[$character.x, $character.y - 1]
#     elsif e.key == "s"
#       $character.y += 1 if $grid[$character.x, $character.y + 1]
#     elsif e.key == "a"
#       $character.x -= 1 if $grid[$character.x - 1, $character.y]
#     elsif e.key == "d"
#       $character.x += 1 if $grid[$character.x + 1, $character.y]
#     end

#     if $grid[$character.x, $character.y].outro_point
#       $grid.each(&:remove)
#       $character.remove

#       $grid = generate_map
#       $character = Character.new(ENTRY_POINT_X, ENTRY_POINT_Y)
#     end
#   end
# end


class MousePointer
  def initialize
    @x, @y = 0, 0
    @mask = Square.new(20, 20, PIXELS_PER_SQUARE, [0, 0, 0, 0.4])
  end

  def color=(color)
    @mask.color = color
    @mask.color.opacity = 0.4
  end

  def x=(x)
    @x = x
    @mask.x = @x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @mask.y = @y * PIXELS_PER_SQUARE
  end
end

class Map
  def passable?(x, y)
    !!$grid[x, y]
  end
end

$mouse_pointer = MousePointer.new
$map = Map.new

Position = Struct.new(:x, :y)

on :mouse_move do |e|
  selected_x = e.x / PIXELS_PER_SQUARE
  selected_y = e.y / PIXELS_PER_SQUARE

  $mouse_pointer.x = selected_x
  $mouse_pointer.y = selected_y

  if $grid[selected_x - $x_offset, selected_y - $y_offset]
    $mouse_pointer.color = "black"
  else
    $mouse_pointer.color = "red"
  end
end

$path = []

on :mouse_down do |e|
  selected_x = e.x / PIXELS_PER_SQUARE - $x_offset
  selected_y = e.y / PIXELS_PER_SQUARE - $y_offset

  position = Position.new(selected_x, selected_y)

  pathfinder = PathFinder.new($character, position, $map)
  path = pathfinder.search

  $path = path
end

$until_move_max = 4
$until_move = $until_move_max

update do
  if $path.any?
    $until_move -= 1

    if $until_move == 0
      $until_move = $until_move_max
      new_spot = $path.shift
      $character.x = new_spot.x
      $character.y = new_spot.y

      if $grid[$character.x, $character.y].outro_point
        $grid.each(&:remove)
        $character.remove

        $grid = generate_map
        $character = Character.new(ENTRY_POINT_X, ENTRY_POINT_Y)
      end

    end
  end
end

show
