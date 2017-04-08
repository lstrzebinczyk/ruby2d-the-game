require "ruby2d"

set({
  title: "Map creation",
  width: 512,
  height: 512,
  # diagnostics: true
  background: "white"
})

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end
end

points_count = 100
points = []

points_count.times do
  points << Point.new(rand, rand)
end

points.each do |point|
  Square.new(512 * point.x, 512 * point.y, 8, "red")
end






show
