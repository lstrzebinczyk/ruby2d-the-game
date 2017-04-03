class PickBerryBushJob
  attr_accessor :taken

  def initialize(berry_bush)
    @berry_bush = berry_bush
    x = berry_bush.x * PIXELS_PER_SQUARE
    y = berry_bush.y * PIXELS_PER_SQUARE

    @taken = false
  end

  def type
    :gathering
  end

  def free?
    !@taken
  end

  def available?
    true
  end

  def target
    @berry_bush
  end

  def action_for(character)
    spot_near_berries     = $map.find_free_spot_near(@berry_bush)
    zone_to_leave_berries = available_zone
    spot_near_zone        = $map.find_free_spot_near(available_zone)

    MoveAction.new(character, spot_near_berries, character).then do
      GatherBerriesAction.new(character, @berry_bush)
    end.then do
      MoveAction.new(spot_near_berries, spot_near_zone, character)
    end.then do
      PutAction.new(zone_to_leave_berries, character, after: ->{ remove })
    end
  end

  def available_zone
    $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? BerriesPile }
  end

  def remove
    $job_list.delete(self)
  end
end
