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
end

# TODO: I can make the lines be prettier
# TODO: Calculate positions smarter and as a quad
# TODO: And draw it smarter
class Line
  def initialize(point_a, point_b)
    @point_a, @point_b = point_a, point_b
    @line_width = 3
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

  def rerender
    @image_a.remove
    @image_b.remove
    @image_a.add
    @image_b.add
  end

  def remove
    # @point_a.remove
    # @point_b.remove
    @image_a.remove
    @image_b.remove
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
    puts "removing #{inspect}"

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
      Point.new(0.1, 0.1),
      Point.new(0.1, 0.9),
      Point.new(0.9, 0.1),
      Point.new(0.9, 0.9)
    ]

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

    # require "pry"
    # binding.pry

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
    points_to_create_new_triangles.sort_by! do |p|
      p.angle(point)
    end

    # require "pry"
    # binding.pry

    @triangles_to_remove.each do |triangle|
      triangle.remove
      @triangles.delete(triangle)
    end


    # require "pry"
    # binding.pry

    # new_triangles = []

    points_to_create_new_triangles.each_cons(2) do |arr|
      @triangles << MeshTriangle.new(arr[0], arr[1], point)
    end

    # require "pry"
    # binding.pry


    # new_triangles.each do |triangle|
    #   @triangles << triangle
    # end

    # list_of_points.each_index do |i|
    #   p1 = list_of_points[i]
    #   p2 = list_of_points[(i+1) % list_of_points.length]

    #   new_polygon = Polygon.new(p1, p2, point)

    #   if new_polygon.field > 0.0001
    #     @polygons << new_polygon
    #     @lines << Line.new(p1, p2)
    #   end

    #   @lines << Line.new(p2, point)
    # end

    p @triangles.inspect
    # p points_to_create_new_triangles.size

    # require "pry"
    # binding.pry
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

# update do
#   70.times do
#     point = Point.new(rand, rand)
#     $mesh.add_point(point)
#   end
# end

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
