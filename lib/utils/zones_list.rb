class ZonesList
  include Enumerable

  attr_reader :grouped_count

  def initialize
    @grid = Grid.new
    @grouped_count = grouped_count_calculation
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

  def recalculate
    @grouped_count = grouped_count_calculation
  end

  private

  def grouped_count_calculation
    map(&:map_object)
      .compact
      .keep_if{|i| i.respond_to?(:count) }
      .group_by(&:class)
      .map{|k, v| { k => v.map(&:count).inject(&:+) } }
      .inject({}, :merge)
  end
end
