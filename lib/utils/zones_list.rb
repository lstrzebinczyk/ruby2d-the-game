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

  def grouped_count
    map(&:map_object)
      .compact
      .keep_if{|i| i.respond_to?(:count) }
      .group_by(&:class)
      .map{|k, v| { k => v.map(&:count).inject(&:+) } }
      .inject({}, :merge)
  end
end
