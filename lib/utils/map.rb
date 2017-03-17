class Map
  class Grid
    def initialize
      @grid_data = {}
    end

    def []=(x, y, value)
      @grid_data[x] ||= {}
      @grid_data[x][y] ||= {}
      @grid_data[x][y] = value
    end

    def [](x, y)
      @grid_data[x] && @grid_data[x][y]
    end

    def each
      @grid_data.each do |key, value|
        value.each do |key, value|
          yield(value)
        end
      end
    end
  end

  def initialize(opts)
    @width  = opts[:width]
    @height = opts[:height]
    @grid   = Grid.new

    fill_grid_with_trees
  end

  def passable?(x, y)
    @grid[x, y].nil?
  end

  def rerender
    @grid.each do |elem|
      elem.rerender
    end
  end

  private

  def set_tree?
    rand < 0.20
  end

  def fill_grid_with_trees
    (0..@width).each do |x|
      (0..@height).each do |y|
        if set_tree?
          @grid[x, y] = Tree.new(x, y)
        end
      end
    end
  end
end
