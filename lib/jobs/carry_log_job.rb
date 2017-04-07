class CarryLogJob
  def initialize(opts)
    @from = opts[:from]
  end

  def type
    :haul
  end

  def available?
    !!available_zone and $flood_map.available?(available_zone.x, available_zone.y)
  end

  def available_zone
    @available_zone ||= $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? Log }
  end

  def target
    @from
  end

  def action_for(character)
    MoveAction.new(character: character, near: @from).then do
      PickAction.new(@from, character)
    end.then do
      MoveAction.new(character: character, near: available_zone)
    end.then do
      PutAction.new(available_zone, character)
    end
  end

  def remove
  end
end
