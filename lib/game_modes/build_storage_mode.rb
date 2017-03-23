class StorageZone
  def initialize(x, y)
    x_coord = (x / PIXELS_PER_SQUARE) * PIXELS_PER_SQUARE
    y_coord = (y / PIXELS_PER_SQUARE) * PIXELS_PER_SQUARE

    @image = Square.new(x_coord, y_coord, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])
    @image.remove
    @image.add
  end

  def remove
    @image.remove
  end
end

class ZonesList
  def initialize
    @grid = Grid.new
  end

  def [](x, y)
    @grid[x, y]
  end

  def []=(x, y, value)
    @grid[x, y] = value
  end
end


$zones = ZonesList.new

class BuildStorageMode
  def click(x, y)
    in_game_x = x / PIXELS_PER_SQUARE
    in_game_y = y / PIXELS_PER_SQUARE

    
    if $zones[in_game_x, in_game_y].nil?
    # $zones[x, y] && $zones[x, y].remove
      $zones[in_game_x, in_game_y] = StorageZone.new(x, y)
    end
  end
end
