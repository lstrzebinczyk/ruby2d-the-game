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
    $zones.each do |zone|
      if zone.has_empty_spot?
        return zone.empty_spot
      end
    end
  end

  def target
    @from
  end

  def action_for(character)
    zone = available_zone
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
