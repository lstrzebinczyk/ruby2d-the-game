class IdlersCount
  def initialize
    @count = 0
    @text = Text.new(
      x: 15,
      y: 55,
      text: "Idlers: 0",
      size: 40,
      font: "fonts/arial.ttf",
      z: ZIndex::GAME_WORLD_TEXT
    )
  end

  def recalculate!
    new_count = $characters_list.count{|char| char.job.is_a? ChillJob }
    if new_count != @count
      @count = new_count
      @text.text = "Idlers: #{@count}"
    end
  end
end
