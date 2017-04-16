class StoreJob
  def initialize(item, opts = {})
    @item = item
    @in   = opts[:in]

    if @item.nil?
      require "pry"
      binding.pry
    end
  end

  def type
    :haul
  end

  def target_place
    @target_place ||= @in || available_zone
  end

  def available?
    zone = available_zone
    !!zone and $flood_map.available?(zone.x, zone.y)
  end

  def available_zone
    $zones.each do |zone|
      spot = zone.empty_spot
      return spot if spot
    end
  end

  def target
    @from
  end

  def action_for(character)
    MoveAction.new(character: character, near: @item).then do
      PickAction.new(@item, character)
    end.then do
      MoveAction.new(character: character, near: target_place)
    end.then do
      PutAction.new(target_place, character, in_container: @in)
    end
  end

  def remove
  end
end
