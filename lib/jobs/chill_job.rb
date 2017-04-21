class ChillJob
  def initialize(opts = {})
    @near = opts[:near]
  end

  def action_for(character)
    if @near
      spot = $map.free_spots_near(@near, 40).to_a.sample

      MoveAction.new(character: character, to: spot).then do
        ChillAction.new(character)
      end
    else
      ChillAction.new(character)
    end
  end

  def remove
  end
end
