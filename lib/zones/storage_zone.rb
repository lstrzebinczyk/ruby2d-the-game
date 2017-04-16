class StorageZone
  Position = Struct.new(:x, :y)

  attr_reader :x, :y, :image
  attr_accessor :taken

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
    @x = x_range.to_a.first
    @y = y_range.to_a.first
    @width  = x_range.last - x_range.first + 1
    @height = y_range.last - y_range.first + 1

    @image = Rectangle.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      @width * PIXELS_PER_SQUARE,
      @height * PIXELS_PER_SQUARE,
      [1, 1, 1, 0.2]
    )

    @image.remove
    @image.add
  end

  def include_any?(fields)
    fields.any? do |f|
      self_fields.include?(f)
    end
  end

  def self_fields
    @self_fields ||= begin
      @x_range.to_a.product(@y_range.to_a)
    end
  end

  def has_empty_spot?
    self_fields.any?{|arr| $map[arr[0], arr[1]].nil? }
  end

  def empty_spot
    spot = self_fields.find do |arr|
      $map[arr[0], arr[1]].nil?
    end
    Position.new(spot[0], spot[1])
  end

  def contain?(object)
    @x_range.cover?(object.x) and @y_range.cover?(object.y)
  end

  def get_job(job_type)
    if job_type == :haul
      item = $map.find_closest_to(self) do |obj|
        obj.is_a? Item and $zones.none?{|zone| zone.contain?(obj) }
      end

      StoreJob.new(item) if item
    end
  end

  # def map_object
  #   $map[@x, @y]
  # end

  # def has_place_for?(object)
  #   if object.category == :food
  #     !map_object.nil? and map_object.is_a? Container and map_object.accepts?(object)
  #   else
  #     map_object.nil?
  #   end
  # end
end
