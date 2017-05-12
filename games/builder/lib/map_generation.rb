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

  def initialize(x, y, opts = {})
    @x, @y = x.to_f, y.to_f
    unless opts[:draw] == false
      @image = Square.new(WINDOW_SIZE * @x, WINDOW_SIZE * @y, 3, "red")
    end
  end

  def angle(other)
    l = Math.sqrt((@x - other.x)**2 + (@y - other.y)**2)

    if other.x >= @x
      return Math.acos((other.y - @y)/l)
    else
      return Math::PI + Math.acos((@y - other.y)/l)
    end
  end

  def remove
    @image.remove
  end

  def inspect
    "(#{@x}, #{@y})"
  end
end

class Line
  def initialize(point_a, point_b)
    @point_a, @point_b = point_a, point_b
    @line_width = 5

    line_length = Math.sqrt((point_a.x - point_b.x)**2 + (point_a.y - point_b.y)**2)
    unit_x = (point_b.x - point_a.x) / line_length
    unit_y = (point_b.y - point_a.y) / line_length

    @image = Quad.new(
      WINDOW_SIZE * @point_a.x - unit_y * @line_width / 2,
      WINDOW_SIZE * @point_a.y + unit_x * @line_width / 2,
      WINDOW_SIZE * @point_a.x + unit_y * @line_width / 2,
      WINDOW_SIZE * @point_a.y - unit_x * @line_width / 2,
      WINDOW_SIZE * @point_b.x + unit_y * @line_width / 2,
      WINDOW_SIZE * @point_b.y - unit_x * @line_width / 2,
      WINDOW_SIZE * @point_b.x - unit_y * @line_width / 2,
      WINDOW_SIZE * @point_b.y + unit_x * @line_width / 2,
      "black"
    )
  end

  def rerender
    @image.remove
    @image.add
  end

  def remove
    @image.remove
  end
end

class MeshTriangle
  class Circle
    attr_accessor :middle, :radius

    # Middle of circumcircle of a triangle is given in such point (Dx, Dy), that
    # [a, b]   [Dx]    [e]
    # [c, d] * [Dy] == [f]
    def initialize(triangle)
      a = 2 * (triangle.p2.x - triangle.p1.x)
      b = 2 * (triangle.p2.y - triangle.p1.y)
      c = 2 * (triangle.p2.x - triangle.p3.x)
      d = 2 * (triangle.p2.y - triangle.p3.y)
      e = triangle.p2.x*triangle.p2.x + triangle.p2.y*triangle.p2.y - triangle.p1.x*triangle.p1.x - triangle.p1.y*triangle.p1.y
      f = triangle.p2.x*triangle.p2.x + triangle.p2.y*triangle.p2.y - triangle.p3.x*triangle.p3.x - triangle.p3.y*triangle.p3.y

      det = a*d - b*c

      x = (d*e - b*f)/det
      y = (a*f - c*e)/det
      r = Math.sqrt((triangle.p1.x - x)**2 + (triangle.p1.y - y)**2)

      @middle = Point.new(x, y, draw: false)
      @radius = r
    end

    def contains?(point)
      # p "Curcle: middle: (#{@middle.x}, #{middle.y}), radius: #{@radius}"
      Math.sqrt((point.x - @middle.x)**2 + (point.y - @middle.y)**2) <= @radius
    end
  end

  attr_reader :p1, :p2, :p3

  def initialize(a, b, c)
    @line_a = Line.new(a, b)
    @line_b = Line.new(b, c)
    @line_c = Line.new(a, c)
    @p1, @p2, @p3 = a, b, c
  end

  def remove
    @line_a.remove
    @line_b.remove
    @line_c.remove
  end

  def rerender
    @line_a.rerender
    @line_b.rerender
    @line_c.rerender
  end

  def inspect
    "<Triangle (#{p1.x}, #{p1.y}) (#{p2.x}, #{p2.y}) (#{p3.x}, #{p3.y})"
  end

  def circumcircle_contains?(point)
    circle.contains?(point)
  end

  def circle
    Circle.new(self)
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

    # @points = [
    #   Point.new(0.1, 0.1),
    #   Point.new(0.1, 0.9),
    #   Point.new(0.9, 0.1),
    #   Point.new(0.9, 0.9)
    # ]

    @triangles = [
      MeshTriangle.new(@points[0], @points[1], @points[2]),
      MeshTriangle.new(@points[1], @points[2], @points[3])
    ]
  end

  def remove_triangle
    triangle = @triangles.shift
    triangle.remove
  end

  def add_point(point)
    @points << point
    @triangles_to_remove = []

    @triangles.each do |triangle|
      if triangle.circumcircle_contains?(point)
        @triangles_to_remove << triangle
      end
    end

    points_to_create_new_triangles = []
    @triangles_to_remove.each do |triangle|
      points_to_create_new_triangles << triangle.p1
      points_to_create_new_triangles << triangle.p2
      points_to_create_new_triangles << triangle.p3
    end

    points_to_create_new_triangles.uniq!
    points_to_create_new_triangles.sort! do |a, b|
      a.angle(point) <=> b.angle(point)
    end

    @triangles_to_remove.each do |triangle|
      triangle.remove
      @triangles.delete(triangle)
    end

    points_to_create_new_triangles.each_index do |i|
      p1 = points_to_create_new_triangles[i]
      p2 = points_to_create_new_triangles[(i+1) % points_to_create_new_triangles.length]
      @triangles << MeshTriangle.new(p1, p2, point)
    end
  end
end

$mesh = Mesh.new

on key_down: "space" do
  point = Point.new(rand, rand)
  $mesh.add_point(point)
end

on mouse: "any" do |x, y|
  point = Point.new(x.to_f / WINDOW_SIZE, y.to_f / WINDOW_SIZE)
  $mesh.add_point(point)
end

on key_down: "q" do
  $mesh.remove_triangle
end

on key_down: "w" do
  p get(:window).objects
end

50.times do
  point = Point.new(rand, rand)
  $mesh.add_point(point)
end

# - allow choosing from delaunay/voronoi view
# - introduce relaxation algorithm

# https://en.wikipedia.org/wiki/Delaunay_triangulation
# calculate a delaunay triangulation, then relaxation once or twice

# http://www-cs-students.stanford.edu/~amitp/game-programming/polygon-map-generation/



show

