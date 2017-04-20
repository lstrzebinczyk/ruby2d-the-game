  # map = MapGenerator.new(SQUARES_WIDTH, SQUARES_HEIGHT).generate
  # map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
  # map.fill_grid_with_objects


class MapGenerator
  def initialize(width, height)
    @width, @height = width, height
  end

  def generate
    @map = Map.new(width: @width, height: @height)
    fill_river
    fill_trees_and_bushes
    @map
  end

  def fill_river
    (0..@width).each do |x|
      (0..@height).each do |y|
        if in_river?(x, y)
          @map[x, y] = River.new(x, y)
        end
      end
    end
  end

  def in_river?(x, y)
    y > river_sinus(x) and y < river_sinus(x) + 4
  end

  def river_sinus(x)
    river_sinus_adder(x) + river_sinus_multiplier * Math.sin(river_in_sinus_alpha(x))
  end

  def river_sinus_adder(x)
    @adder_rand ||= rand + rand + rand
    x * 0.07 + @adder_rand
  end

  def river_sinus_multiplier
    @multiplier ||= 2.3 + 2 * rand + 2 * rand
  end

  def river_in_sinus_alpha(x)
    @tr ||= rand - rand + rand - rand
    @ml ||= 0.1 + rand/10 - rand/10

    @tr + x * @ml
  end

  def fill_trees_and_bushes
    (0..@width).each do |x|
      (0..@height).each do |y|
        if @map[x, y].nil?
          if set_tree?(x, y)
            @map[x, y] = Tree.new(x, y)
          elsif set_bush?(x, y)
            @map[x, y] = BerryBush.new(x, y)
          end
        end
      end
    end

    @noise_cache = nil
  end

  def noise_generator
    @noise ||= RandomNoiseGenerator.new
  end

  def set_tree?(x, y)
    rand < get_noise(x, y)
  end

  def set_bush?(x, y) # of love
    rand < (get_noise(x, y) / 2)
  end

  def get_noise(x, y)
    noise_cache[x] ||= {}
    noise_cache[x][y] ||= noise_generator.get(x, y)
    noise_cache[x][y]
  end

  def noise_cache
    @noise_cache ||= {}
  end
end
