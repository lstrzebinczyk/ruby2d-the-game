class MapPosition
  include Observable

  attr_reader :offset_x, :offset_y

  def initialize
    @offset_x = 0
    @offset_y = 0
  end

  def offset_x=(offset_x)
    @offset_x = offset_x
    private_notify_observers
  end

  def offset_y=(offset_y)
    @offset_y = offset_y
    private_notify_observers
  end

  private

  def private_notify_observers
    changed
    notify_observers(@offset_x, @offset_y)
  end
end
