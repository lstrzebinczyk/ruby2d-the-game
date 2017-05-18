require "pathname"

engine_path = Pathname.new("./../../").realpath.to_s
$LOAD_PATH.unshift(engine_path)

require "engine/grid"

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
  attr_reader :filled, :x, :y

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

  def x=(x)
    @x = x
    @image.x = @x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = @y * PIXELS_PER_SQUARE
  end
end

$character = Character.new(ENTRY_POINT_X, ENTRY_POINT_Y)


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

on :key_down do |e|
  if e.key == "w"
    $character.y -= 1 if $grid[$character.x, $character.y - 1]
  elsif e.key == "s"
    $character.y += 1 if $grid[$character.x, $character.y + 1]
  elsif e.key == "a"
    $character.x -= 1 if $grid[$character.x - 1, $character.y]
  elsif e.key == "d"
    $character.x += 1 if $grid[$character.x + 1, $character.y]
  end
end


show
