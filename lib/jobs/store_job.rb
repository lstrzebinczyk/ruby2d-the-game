class StoreJob
  def initialize(item)
    @item = item

    if @item.nil?
      require "pry"
      binding.pry
    end
  end

  def type
    :haul
  end

  def available?
    zone = available_zone
    !!zone and $flood_map.available?(zone.x, zone.y)
  end

  def available_zone
    $zones.find do |zone|
      zone.is_a? StorageZone and zone.has_place_for?(@item) and !zone.taken
    end
  end

  def target
    @from
  end

  def action_for(character)
    zone = available_zone
    zone.taken = true
    MoveAction.new(character: character, near: @item).then do
      PickAction.new(@item, character)
    end.then do
      MoveAction.new(character: character, near: zone)
    end.then do
      PutAction.new(zone, character)
    end
  end

  def remove
  end
end
