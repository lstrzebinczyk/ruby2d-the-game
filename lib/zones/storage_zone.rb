class StorageZone
  attr_reader :x, :y 
  
  def initialize(x, y)
    @x = x 
    @y = y

    x_coord = x * PIXELS_PER_SQUARE
    y_coord = y * PIXELS_PER_SQUARE

    @image = Square.new(x_coord, y_coord, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])
    @image.remove
    @image.add
  end

  def map_object
    $map[@x, @y]
  end

  def has_place_for?(object_class)
    if map_object.nil?
      true
    elsif map_object.is_a? object_class
      map_object.can_carry_more?
    end
  end

  def remove
    @image.remove
  end
end
