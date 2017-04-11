class EatJob
  def initialize(opts)
    @from = opts[:from]

    unless @from
      raise ArgumentError, "EatJob requires a :from key, received '#{@from.inspect}'"
    end
  end

  def action_for(character)
    MoveAction.new(character: character, near: @from).then do
      PickAction.new(@from, character)
    end.then do
      # TODO: Should go to a table and chair if there is a diner, or own house
      fireplace = $structures.find{|s| s.is_a? Fireplace }
      MoveAction.new(character: character, near: fireplace || character)
    end.then do
      EatAction.new(character)
    end
  end

  def remove
  end
end
