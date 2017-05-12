class Background
  def initialize
    MapRenderer.image(0, 0, "assets/nature/background.png", ZIndex::BACKGROUND)
    MapRenderer.image(0, 790 / PIXELS_PER_SQUARE, "assets/nature/background.png", ZIndex::BACKGROUND)
    MapRenderer.image(0, 2 * 790 / PIXELS_PER_SQUARE, "assets/nature/background.png", ZIndex::BACKGROUND)
  end
end
