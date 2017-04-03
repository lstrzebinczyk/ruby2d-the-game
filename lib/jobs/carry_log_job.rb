class CarryLogJob
  attr_writer :taken

  def initialize(opts)
    @from = opts[:from]
    @taken = false
  end

  def type
    :haul
  end

  def free?
    !@taken
  end

  def available?
    !!available_zone
  end

  def available_zone
    $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? LogsPile }
  end

  def target
    @from
  end

  def action_for(character)
    to = available_zone
    spot_near_to   = $map.find_free_spot_near(to)

    MoveAction.new(character: character, to: spot_near_to).then do
      PickAction.new(@from, character)
    end.then do
      MoveAction.new(character: character, to: spot_near_to)
    end.then do
      PutAction.new(to, character, after: ->{ remove })
    end
  end

  def remove
    $job_list.delete(self)
  end
end
