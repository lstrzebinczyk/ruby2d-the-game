class FpsDrawer
  def initialize
    @text = Text.new(
      x: 15,
      y: 15,
      text: "fps: 0",
      size: 40,
      font: "fonts/arial.ttf",
      z: ZIndex::GAME_WORLD_TEXT
    )
  end

  def rerender(fps)
    @text.text = "fps: #{fps.to_i}"
  end
end
