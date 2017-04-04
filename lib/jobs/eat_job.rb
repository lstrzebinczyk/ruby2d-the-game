class EatJob
  def initialize(opts)
    @from = opts[:from]

    unless @from
      raise ArgumentError, "EatJob requires a :from key, received '#{@from.inspect}'"
    end
  end

  def action_for(character)
    MoveAction.new(character: character, near: @from).then do
      if @from.is_a? BerriesPile
        PickAction.new(@from, character)
      elsif @from.is_a? BerryBush
        GatherBerriesAction.new(character, @from)
      end
    end.then do
      fireplace = $structures.find{|s| s.is_a? Fireplace }
      MoveAction.new(character: character, near: fireplace || character)
    end.then do
      EatAction.new(character)
    end
  end

  def remove
  end
end
