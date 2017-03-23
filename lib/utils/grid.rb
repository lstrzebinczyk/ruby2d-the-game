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
