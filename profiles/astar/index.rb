require "ruby-prof"
require "pathname"
require_relative "./../../lib/a_star"

class Map
  def passable?(x, y)
    true
  end
end

def check(x0, y0, x1, y1)
  start       = { 'x' => x0, 'y' => y0 }
  destination = { 'x' => x1, 'y' => y1 }
  astar       = Astar.new(start, destination, Map.new)
  result      = astar.search # returns Array
end



RubyProf.start

check(0, 0, 10, 10)
check(2, 3, 13, 21)
check(9, 3, 23, 29)

result = RubyProf.stop

puts "Printing..."
printer = RubyProf::GraphHtmlPrinter.new(result)
# printer = RubyProf::CallStackPrinter.new(result)
# RubyProf::CallStackPrinter

Pathname.new(FileUtils.pwd).join("./profiles/astar/astar.html").open("w+") do |file|
  printer.print(file, {})
end
