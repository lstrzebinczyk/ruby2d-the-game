class FishCleaningJob
  def initialize(opts)
    @at = opts[:at]
  end

  def type
    :fish_cleaning
  end

  def target
    [CleanedFish, @at]
  end

  def action_for(character)
    MoveAction.new(character: character, to: @at).then do
      ProduceAction.new(CleanedFish, at: @at, character: character)
    end
  end

  def remove
  end
end
