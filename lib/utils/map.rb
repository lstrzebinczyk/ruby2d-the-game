class Map
  class Spot
    attr_accessor :x, :y, :terrain
    attr_reader :content

    def initialize(opts = {})
      @x         = opts[:x]
      @y         = opts[:y]
      @terrain   = opts[:terrain]
      @available = opts[:available]
      @content   = opts[:content]
    end

    def content=(content)
      if @content
        raise "Can't put anything new here!"
      else
        @content = content
        @content.x = @x
        @content.y = @y
        @content.render
      end
    end

    def passable?
      @terrain.passable? and (!@content.respond_to?(:impassable?) or !@content.impassable?)
    end

    # TODO: Update the flood map!!!
    def clear_content
      @content && content.remove
      @content = nil
      nil
      $flood_map and $flood_map.set_as_available(x, y)
    end

    def rerender
      @terrain.remove
      @content.remove if @content
      @terrain.render
      @content.render if @content
    end
  end

  attr_reader :width, :height

  def initialize(opts)
    @width  = opts[:width]
    @height = opts[:height]
    @grid   = Grid.new

    (0..@width).each do |x|
      (0..@height).each do |y|
        @grid[x, y] = Spot.new(x: x, y: y)
      end
    end
  end

  def [](x, y)
    @grid[x, y]
  end

  def passable_spots_near(position)
    spots_near(position) do |spot|
      spot.passable?
    end
  end

  def free_spots_near(position)
    spots_near(position) do |spot|
      spot.content.nil?
    end
  end

  def spots_near(position, &block)
    enumerator = search_path(position.x, position.y)
    enumerator = enumerator.find_all(&block) if block_given?
    enumerator
  end

  def rerender
    @grid.each(&:rerender)
  end

  private

  DIRECTIONS = [
    [ 1,  0],
    [ 0,  1],
    [-1,  0],
    [ 0, -1]
  ]

  def search_path(x, y)
    odd_numbers
      .drop(1)
      .flat_map { |radius| square_edge_coordinates(x, y, radius) }
      .take(2000) # So that we will not look for things forever
      .reject { |spot| spot.nil? }
      .reject { |spot| !$flood_map.available?(spot.x, spot.y) }
  end

  def odd_numbers
    (0...Float::INFINITY)
      .lazy
      .map { |x| 1 + 2 * x }
  end

  def square_edge_coordinates(center_x, center_y, radius)
    position = [center_x - radius/2, center_y - radius/2]

    DIRECTIONS.lazy
      .flat_map do |direction|
        [direction].lazy
          .cycle
          .take(radius.pred)
      end
      .map do |step|
        response = self[position[0], position[1]]
        position[0] += step[0]
        position[1] += step[1]
        response
      end
  end
end

