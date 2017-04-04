class SleepJob
  def initialize(opts)
    @at = opts[:at]
    if opts[:near]
      @at = $map.find_free_spot_near(opts[:near])
    end
  end

  def action_for(character)
    MoveAction.new(character: character, near: @at).then do
      SleepAction.new(character)
    end
  end

  def remove
  end
end
