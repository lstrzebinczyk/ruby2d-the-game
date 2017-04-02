# TT.......SS
# TT.......SS
# TT....C..SS
# TT.......SS
# TT.......SS

template = """
TT.......SS
TT.......SS
TT....C..SS
TT.......SS
TT.......SS
"""


# require "pry"

# binding.pry

# T => Tree
# C => Character, woodcutter here
# S => Storage zone

class MapBuilder
  def initialize(template)
    @template_data = template.split("\n").keep_if{|line| line.length > 0}.map{|line| line.split("") }
  end

  def build
    map = Map.new
    @template_data.each_with_index do |line, y|
      line.each_with_index do |symbol, x|
        # puts "(#{x}, #{y}) => #{symbol}"
      end
    end
  end
end

MapBuilder.new(template)
