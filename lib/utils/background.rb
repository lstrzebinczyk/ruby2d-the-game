class Background
  def initialize
    @image = Image.new(
      0,
      0,
      "assets/nature/background.png",
      ZIndex::BACKGROUND
      )
    $map_position.add_observer(self, :update_offset)
  end

  def update_offset(offset_x, offset_y)
    @image.x = offset_x
    @image.y = offset_y
  end
end
