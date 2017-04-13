class RemoveGameMode < GameMode::Base::Area
  Position = Struct.new(:x, :y)

  def perform(in_game_x_range, in_game_y_range)
    in_game_x_range.each do |x|
      in_game_y_range.each do |y|
        perform_point(x, y)
      end
    end
  end

  def perform_point(in_game_x, in_game_y)
    map_object = $map[in_game_x, in_game_y]
    if map_object.is_a? BerryBush
      if $characters_list.any? {|c| c.job.is_a? CutBerryBushJob and c.job.target == map_object}
        # do nothing
      elsif $job_list.has?(CutBerryBushJob, map_object)
        # do nothing
      else
        new_job = CutBerryBushJob.new(map_object)
        $job_list.add(new_job)
      end
    end
  end
end
