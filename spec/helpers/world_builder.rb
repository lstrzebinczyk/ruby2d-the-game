# TT.......SS
# TT.......SS
# TT....C..SS
# TT.......SS
# TT.......SS

# T => Tree
# C => Character, woodcutter here
# S => Storage zone
# L => Logs pile

class WorldBuilder
  def initialize(template, opts = {})
    @template_data = template.split("\n").keep_if{|line| line.length > 0}.map{|line| line.split("") }
    @opts = opts
    @berry_bush_grams = opts[:berry_bush_grams] || 5000
  end

  def build
    map   = Map.new(width: @template_data.first.length, height: @template_data.length)
    chars = []
    @template_data.each_with_index do |line, y|
      line.each_with_index do |symbol, x|
        case symbol
        when "T"
          map[x, y] = Tree.new(x, y)
        when "L"
          map[x, y] = LogsPile.new(x, y, 1)
        when "B"
          map[x, y] = BerryBush.new(x, y, @berry_bush_grams)
        when "R"
          map[x, y] = BerriesPile.new(x, y, 1234)
        when "W"
          chars << Character.new(x: x, y: y, name: "Char ##{chars.length + 1}", type: :woodcutter)
        when "G"
          chars << Character.new(x: x, y: y, name: "Char ##{chars.length + 1}", type: :gatherer)
        end
      end
    end

    game_world = GameWorld.new(chars, map)

    @template_data.each_with_index do |line, y|
      line.each_with_index do |symbol, x|
        case symbol
        when "S"
          SetStorageGameMode.new.perform(x, y)
        end
      end
    end

    if @opts[:fireplace]
      $structures << Fireplace.new
    end

    game_world
  end
end
