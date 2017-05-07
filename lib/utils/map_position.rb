class MapPosition
  include Observable

  attr_reader :offset_x, :offset_y

  def initialize
    @offset_x = 0
    @offset_y = 0

    @min_offset_x = -(WORLD_SQUARES_WIDTH - SQUARES_WIDTH) * PIXELS_PER_SQUARE
    @min_offset_y = -(WORLD_SQUARES_HEIGHT - SQUARES_HEIGHT) * PIXELS_PER_SQUARE
  end

  def offset_x=(offset_x)
    @offset_x = offset_x
    normalize_x
    private_notify_observers
  end

  def update_offset(delta_x, delta_y)
    @offset_x += delta_x
    @offset_y += delta_y

    normalize_x
    normalize_y

    private_notify_observers
  end

  def offset_y=(offset_y)
    @offset_y = offset_y
    normalize_y
    private_notify_observers
  end

  private

  def normalize_x
    if @offset_x >= 0
      @offset_x = 0
    elsif @offset_x <= @min_offset_x
      @offset_x = @min_offset_x
    end
  end

  def normalize_y
    if @offset_y >= 0
      @offset_y = 0
    elsif @offset_y <= @min_offset_y
      @offset_y = @min_offset_y
    end
  end

  def private_notify_observers
    changed
    notify_observers(@offset_x, @offset_y)
  end
end
