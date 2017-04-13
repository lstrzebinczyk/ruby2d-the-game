class ChillJob
  def action_for(character)
    fireplace = $structures.find{|s| s.is_a? Fireplace }
    if fireplace
      spot = $map.free_spots_near(fireplace, 40).to_a.sample

      MoveAction.new(character: character, to: spot).then do
        ChillAction.new(character)
      end
    else
      ChillAction.new(character)
    end
  end

  def remove
  end
end
