class ProduceJob
  def initialize(item_type, opts)
    @item_type = item_type
    @at        = opts[:at]

    if @item_type != :table
      raise ArgumentError, "Need to think this better"
    end
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
      ProduceAction.new(@item_type, at: @at)
    end
  end

  def remove
  end
end
