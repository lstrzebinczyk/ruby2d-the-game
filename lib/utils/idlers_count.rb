class IdlersCount
  def initialize
    @count = 0
    @text = Text.new(15, 55, "Idlers: 0", 40, "fonts/arial.ttf", "white", ZIndex::GAME_WORLD_TEXT)
  end

  def recalculate!
    new_count = $characters_list.count{|char| char.job.is_a? ChillJob }
    if new_count != @count
      @count = new_count
      @text.text = "Idlers: #{@count}"
    end
  end
end
