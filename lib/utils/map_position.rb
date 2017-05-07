class MapPosition
  include Observable

  attr_reader :offset_x, :offset_y

  def initialize
    @offset_x = 0
    @offset_y = 0

    @min_offset_x = -(WORLD_SQUARES_WIDTH - SQUARES_WIDTH) * PIXELS_PER_SQUARE
    @min_offset_y = -(WORLD_SQUARES_HEIGHT - SQUARES_HEIGHT) * PIXELS_PER_SQUARE
  end

  # lewo, offset_x rośnie
  # prawo, offset_x maleje

  # do góry, offset y rośnie
  # na dół, offset y maleje


  def offset_x=(offset_x)
    @offset_x = offset_x

    if @offset_x >= 0
      @offset_x = 0
    elsif @offset_x <= @min_offset_x
      @offset_x = @min_offset_x
    end

    private_notify_observers
  end

  def offset_y=(offset_y)
    @offset_y = offset_y

    if @offset_y >= 0
      @offset_y = 0
    elsif @offset_y <= @min_offset_y
      @offset_y = @min_offset_y
    end

    private_notify_observers
  end

  private

  def private_notify_observers
    changed
    notify_observers(@offset_x, @offset_y)
  end
end
