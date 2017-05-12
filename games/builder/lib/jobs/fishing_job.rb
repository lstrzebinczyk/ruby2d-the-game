class FishingJob
  def type
    :fishing
  end

  def action_for(character)
    river_spot = $map.spots_near(character).find do |spot|
      spot.terrain.is_a? River
    end

    MoveAction.new(character: character, near: river_spot).then do
      FishAction.new(character)
    end
  end

  def remove
  end
end
