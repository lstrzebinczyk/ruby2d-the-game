require "ruby2d"

WINDOW_SIZE = 512

set({
  title: "Map creation",
  width: WINDOW_SIZE,
  height: WINDOW_SIZE,
  # diagnostics: true
  background: "white"
})

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @image = Square.new(WINDOW_SIZE * @x, WINDOW_SIZE * @y, 3, "red")
  end
end

# TODO: I can make the lines be prettier
# TODO: Calculate positions smarter and as a quad
# TODO: And draw it smarter
class Line
  def initialize(point_a, point_b)
    @point_a, @point_b = point_a, point_b
    @line_width = 2
    @image_a = Triangle.new(
      @point_a.x * WINDOW_SIZE,
      @point_a.y * WINDOW_SIZE,
      @point_a.x * WINDOW_SIZE + @line_width,
      @point_a.y * WINDOW_SIZE + @line_width,
      @point_b.x * WINDOW_SIZE,
      @point_b.y * WINDOW_SIZE,
      "black"
    )
    @image_b = Triangle.new(
      @point_a.x * WINDOW_SIZE,
      @point_a.y * WINDOW_SIZE,
      @point_b.x * WINDOW_SIZE,
      @point_b.y * WINDOW_SIZE,
      @point_b.x * WINDOW_SIZE + @line_width,
      @point_b.y * WINDOW_SIZE + @line_width,
      "black"
    )
  end
end

class MeshTriangle
  def initialize(a, b, c)
    @line_a = Line.new(a, b)
    @line_b = Line.new(b, c)
    @line_c = Line.new(a, c)
  end
end

class Mesh
  def initialize
    @points = [
      Point.new(0, 0),
      Point.new(0, 1),
      Point.new(1, 0),
      Point.new(1, 1)
    ]

    @triangles = [
      MeshTriangle.new(@points[0], @points[1], @points[2]),
      MeshTriangle.new(@points[1], @points[2], @points[3])
    ]

    # @lines = [
    #   Line.new(@points[0], @points[1]),
    #   Line.new(@points[0], @points[2]),
    #   Line.new(@points[3], @points[1]),
    #   Line.new(@points[3], @points[2]),
    #   Line.new(@points[1], @points[2])
    # ]
  end
end

Mesh.new

# p = Point.new(rand, rand)
# q = Point.new(rand, rand)
# Line.new(p, q)

# points_count = 100
# points = []

# points_count.times do
#   points << Point.new(rand, rand)
# end

# https://en.wikipedia.org/wiki/Delaunay_triangulation
# calculate a delaunay triangulation, then relaxation once or twice

# http://www-cs-students.stanford.edu/~amitp/game-programming/polygon-map-generation/



show
