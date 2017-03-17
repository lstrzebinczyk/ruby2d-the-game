class Background
  def initialize
    @image = Image.new(0, 0, "assets/nature/background.png")
  end

  def rerender
    @image.remove
    @image.add
  end
end
