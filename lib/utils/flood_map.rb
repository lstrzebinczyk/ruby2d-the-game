class FloodMap
  class Position
    attr_reader :x, :y, :checked_times

    def initialize(x, y)
      @x, @y = x, y
      @checked_times = 0
    end

    def check!
      @checked_times += 1
    end
  end

  def initialize(map, characters)
    @map        = map
    @characters = characters

    @availability_grid = Array.new(@map.height) { Array.new(@map.width){ nil } }
    @positions_to_check = []
    @positions_to_check_later = []

    @characters.each do |character|
      @availability_grid[character.y][character.x] = :ok
    end

    @characters.each do |character|
      [-1, 0, 1].each do |x_delta|
        [-1, 0, 1].each do |y_delta|
          add_as_checking(character.x + x_delta, character.y + y_delta)
        end
      end
    end

    @renderable = []

    calculate!
  end

  def calculate!
    while @positions_to_check.any? or @positions_to_check_later.any?
      progress
    end
  end

  def set_as_available(x, y)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |arr|
      x_delta = arr[0]
      y_delta = arr[1]
      # add_as_checking(x + x_delta, y + y_delta)

      unless @availability_grid[y + y_delta][x + x_delta] == :ok
        if @map.in_map?(x + x_delta, y + y_delta)
          @positions_to_check << Position.new(x + x_delta, y + y_delta)
          @availability_grid[y + y_delta][x + x_delta] = :checking
        end
      end
    end

    calculate!
  end

  def add_as_checking(x, y)
    unless @availability_grid.dig(y, x)
      if @map.in_map?(x, y)
        @positions_to_check << Position.new(x, y)
        @availability_grid[y][x] = :checking
      end
    end
  end

  def progress
    position = @positions_to_check.shift
    if position
      x        = position.x
      y        = position.y

      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |arr|
        x_delta = arr[0]
        y_delta = arr[1]

        if @availability_grid.dig(y + y_delta, x + x_delta) == :ok and @map.passable?(x + x_delta, y + y_delta)
          @availability_grid[y][x] = :ok

          if @renderable.any?
            rendered = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, PIXELS_PER_SQUARE, "green")
            rendered.color.opacity = 0.2
            @renderable << rendered
          end

          [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |arr|
            x_inner_delta = arr[0]
            y_inner_delta = arr[1]
            add_as_checking(x + x_inner_delta, y + y_inner_delta)
          end

          return
        end
      end

      unless position.checked_times >= 5
        position.check!
        @positions_to_check_later << position
      end
    else
      if @positions_to_check_later.any?
        @positions_to_check = @positions_to_check_later
        @positions_to_check_later = []
      end
    end
  end

  def toggle
    if @renderable.any?
      @renderable.each(&:remove)
      @renderable = []
    else
      @availability_grid.each_with_index do |row, y|
        row.each_with_index do |value, x|
          if value
            if value == :ok
              rendered = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, PIXELS_PER_SQUARE, "green")
              rendered.color.opacity = 0.2
              @renderable << rendered
            end
          end
        end
      end
    end
  end
end
