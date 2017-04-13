class StorageZone
  attr_reader :x, :y, :image
  attr_accessor :taken

  def initialize(x, y)
    @x = x
    @y = y

    x_coord = x * PIXELS_PER_SQUARE
    y_coord = y * PIXELS_PER_SQUARE

    @image = Square.new(x_coord, y_coord, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])
    @image.remove
    @image.add
    @taken = false
  end

  def map_object
    $map[@x, @y]
  end

  def has_place_for?(object)
    if object.category == :food
      !map_object.nil? and map_object.is_a? Container and map_object.accepts?(object)
    else
      map_object.nil?
    end
  end
end
