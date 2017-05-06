class Background
  def initialize
    @image = MapRenderer.image(0, 0, "assets/nature/background.png", ZIndex::BACKGROUND)
  end
end
