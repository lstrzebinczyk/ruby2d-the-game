class ChillJob
  def initialize(opts = {})
    @near = opts[:near]
    @at   = opts[:at]
    @area = opts[:area] || 40
  end

  def action_for(character)
    if @near
      spot = $map.free_spots_near(@near).take(@area).to_a.sample

      MoveAction.new(character: character, to: spot).then do
        ChillAction.new(character)
      end
    elsif @at
      MoveAction.new(character: character, to: @at).then do
        ChillAction.new(character)
      end
    else
      ChillAction.new(character)
    end
  end

  def remove
  end
end
