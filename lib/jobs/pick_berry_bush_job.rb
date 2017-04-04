class PickBerryBushJob
  def initialize(berry_bush)
    @berry_bush = berry_bush
  end

  def type
    :gathering
  end

  def available?
    true
  end

  def target
    @berry_bush
  end

  def action_for(character)
    MoveAction.new(character: character, near: @berry_bush, log: "to bush").then do
      GatherBerriesAction.new(character, @berry_bush)
    end.then do
      MoveAction.new(character: character, near: available_zone, log: "to zone")
    end.then do
      PutAction.new(available_zone, character)
    end
  end

  def available_zone
    @available_zone ||= $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? Berries }
  end

  def remove
  end
end
