class CookingJob
  def initialize(item_class, opts)
    @item_class = item_class
    @at = opts[:at]
  end

  def type
    :fish_cleaning
  end

  def target
    [@item_class, @at]
  end

  def action_for(character)
    MoveAction.new(character: character, to: @at).then do
      ProduceAction.new(@item_class, at: @at, character: character)
    end
  end

  def remove
  end
end
