class BuildJob
  def initialize(opts)
    @structure = opts[:structure]
  end

  def type
    :building
  end

  def available?
    true
  end

  def target
    @structure
  end

  def action_for(character)
    MoveAction.new(character: character, near: @structure).then do
      BuildAction.new(@structure, character)
    end
  end

  def remove
  end
end
