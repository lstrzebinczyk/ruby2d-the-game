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
      @text = Text.new(610, 52, "Game speed: x#{number}", 40, "fonts/arial.ttf", "white", ZIndex::GAME_WORLD_TEXT)
    end
  end
end
