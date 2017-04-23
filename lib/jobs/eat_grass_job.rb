class EatGrassJob
  def initialize(opts)
    @at = opts[:at]
  end

  def action_for(character)
    EatGrassAction.new(@at)
  end

  def remove
  end
end
