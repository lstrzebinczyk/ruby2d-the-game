class StoreJob
  def initialize(item)
    @item = item
  end

  def type
    :haul
  end

  def available?
    !!available_zone and $flood_map.available?(available_zone.x, available_zone.y)
  end

  def available_zone
    @available_zone ||= $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? @item.class }
  end

  def target
    @from
  end

  def action_for(character)
    puts "TAKING STOREJOB"
    MoveAction.new(character: character, near: @item).then do
      PickAction.new(@item, character)
    end.then do
      MoveAction.new(character: character, near: available_zone)
    end.then do
      PutAction.new(available_zone, character)
    end
  end

  def remove
  end
end
