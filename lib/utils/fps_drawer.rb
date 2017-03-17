class FpsDrawer
  def initialize
    @text = Text.new(15, 15, "fps: 0", 40, "fonts/arial.ttf")
  end

  def rerender(fps)
    @text.remove
    @text.text = "fps: #{fps.to_i}"
    @text.add
  end
end
