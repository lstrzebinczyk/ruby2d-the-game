class FishingJob
  def type
    :fishing
  end

  def action_for(character)
    river_tile = $map.find_closest_to(character) do |tile|
      tile.is_a?(River)
    end

    MoveAction.new(character: character, near: river_tile).then do
      FishAction.new(character)
    end
  end

  def remove
  end
end
