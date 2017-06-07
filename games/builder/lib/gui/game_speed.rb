class GameSpeed
  attr_reader :value

  def initialize
    @value = 1
  end

  def set(number)
    @value = number
    @text && @text.remove
    @text = nil
    unless number == 1
      @text = Text.new(
        x: 610,
        y: 52,
        text: "Game speed: x#{number}",
        size: 40,
        font: "fonts/arial.ttf",
        z: ZIndex::GAME_WORLD_TEXT
      )
    end
  end
end
