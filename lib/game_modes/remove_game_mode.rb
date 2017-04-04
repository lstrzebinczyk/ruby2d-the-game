class RemoveGameMode < GameMode::Base
  def perform(in_game_x, in_game_y)
    map_object = $map[in_game_x, in_game_y]
    if map_object.is_a? BerryBush
      if $characters_list.any? {|c| c.job.is_a? CutBerryBushJob and c.job.target == map_object}
        # do nothing
      elsif $job_list.has?(CutBerryBushJob, map_object)
        job = $job_list.find(CutBerryBushJob, map_object)
        $job_list.delete(job)
        job.remove
      else
        new_job = CutBerryBushJob.new(map_object)
        $job_list.add(new_job)
      end
    end

  end
end
