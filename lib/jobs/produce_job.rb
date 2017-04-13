class ProduceJob
  attr_reader :item_type

  def initialize(item_type, opts)
    @item_type = item_type
    @at        = opts[:at]
  end

  def type
    :carpentry
  end

  def available?
    @at.has_stuff_required_for(@item_type)
  end

  def target
    [@item_type, @at]
  end

  def action_for(character)
    MoveAction.new(character: character, to: @at).then do
      ProduceAction.new(@item_type, at: @at, character: character)
    end
  end

  def remove
  end
end
