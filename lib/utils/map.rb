class Map
  class Spot
    attr_accessor :x, :y, :terrain, :available, :availability_checked_times
    attr_reader :content

    def initialize(opts = {})
      @x         = opts[:x]
      @y         = opts[:y]
      @terrain   = opts[:terrain]
      @available = opts[:available]
      @content   = opts[:content]

      @availability_checked_times = 0
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
    spots_near(position).find_all do |spot|
      spot.passable?
    end
  end

  def free_spots_near(position)
    spots_near(position).find_all do |spot|
      spot.content.nil?
    end
  end

  def spots_near(position)
    search_path(position.x, position.y)
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
      .reject { |spot| spot.nil? || !spot.available }
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

  def calculate_availability(characters)
    @positions_to_check = []
    @positions_to_check_later = []

    characters.each do |character|
      [-1, 0, 1].each do |x_delta|
        [-1, 0, 1].each do |y_delta|
          x = character.x + x_delta
          y = character.y + y_delta
          if self[x, y]
            @positions_to_check << self[x, y]
            self[x, y].available = :checking
          end
        end
      end
    end

    characters.each do |character|
      self[character.x, character.y].available = :ok
    end

    while @positions_to_check.any? or @positions_to_check_later.any?
      progress_availability
    end
  end

  def progress_availability
    position = @positions_to_check.shift
    # p "will check position (#{position.x}, #{position.y})"
    if position
      x        = position.x
      y        = position.y

      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |arr|
        x_delta = arr[0]
        y_delta = arr[1]

        if self[x + x_delta, y + y_delta] and self[x + x_delta, y + y_delta].available == :ok and self[x + x_delta, y + y_delta].passable?
          # p "Set (#{x}, #{y}) as ok"
          self[x, y].available = :ok

          [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |arr|
            x_inner = x + arr[0]
            y_inner = y + arr[1]

            if self[x_inner, y_inner] and self[x_inner, y_inner].available.nil?
              @positions_to_check << self[x_inner, y_inner]
              self[x_inner, y_inner].available = :checking
            end
          end

          return
        end
      end

      unless position.availability_checked_times >= 5
        position.availability_checked_times += 1
        @positions_to_check_later << position
      end
    else
      if @positions_to_check_later.any?
        @positions_to_check = @positions_to_check_later
        @positions_to_check_later = []
      end
    end
  end
end
