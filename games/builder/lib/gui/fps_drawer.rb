class FpsDrawer
  def initialize
    @text = Text.new(15, 15, "fps: 0", 40, "fonts/arial.ttf", "white", ZIndex::GAME_WORLD_TEXT)
  end

  def rerender(fps)
    @text.text = "fps: #{fps.to_i}"
  end
end
