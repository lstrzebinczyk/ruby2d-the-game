class ZonesList
  include Enumerable

  def initialize
    @grid = Grid.new
  end

  def [](x, y)
    @grid[x, y]
  end

  def []=(x, y, value)
    @grid[x, y] = value
  end

  def each(&block)
    @grid.each(&block)
  end
end
