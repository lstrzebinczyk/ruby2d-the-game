class PickBerryBushJob
  attr_accessor :taken

  def initialize(berry_bush)
    @berry_bush = berry_bush
    x = berry_bush.x * PIXELS_PER_SQUARE
    y = berry_bush.y * PIXELS_PER_SQUARE

    @taken = false
  end

  def type
    :woodcutting
  end

  def inspect
    "#<PickTreeJob @y=#{@tree.y}, @x=#{@tree.x}, @taken=#{@taken}>"
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

    MoveAction.new(character, spot_near_berries, character).then do
      PickBerriesAction.new(@berry_bush, character)
    end.then do 
      MoveAction.new(spot_near_berries, zone_to_leave_berries, character)
    end.then do 
      PutAction.new(zone_to_leave_berries, character, after: ->{ remove })
    end
  end

  def available_zone
    $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? BerriesPile }
  end

  def remove
    @mask.remove
    $job_list.delete(self)
  end
end
