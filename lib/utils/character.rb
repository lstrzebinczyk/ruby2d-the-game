class Character
  def initialize(x, y)
    @image         = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
    @move_to_point = nil      # Point to which the character is trying to get
    @path          = Path.new # Path that leads him to it
  end

  def x
    @image.x / PIXELS_PER_SQUARE
  end

  def y
    @image.y / PIXELS_PER_SQUARE
  end

  def update(x, y)
    @image.remove
    @image.x = x * PIXELS_PER_SQUARE
    @image.y = y * PIXELS_PER_SQUARE
    @image.add
  end

  def rerender
    @image.remove
    @image.add
  end

  def move_to(x, y)
    @move_to_point = ActionPoint.new(x, y)
    calculate_path_to(x, y)
  end

  def move
    if @path.any?
      next_step = @path.shift_node
      update(next_step.x, next_step.y)
    end
  end

  private

  def calculate_path_to(x, y)
  # puts "Looking path from (#{@character_position.x}, #{@character_position.y}) to  (#{x}, #{y})"
    start       = { 'x' => $character.x, 'y' => $character.y }
    destination = { 'x' => x, 'y' => y }
    result      = PathFinder.new(start, destination, $map).search
    @path.update(result)
  end
end
