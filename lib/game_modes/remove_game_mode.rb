class RemoveGameMode < GameMode::Base
  def perform(in_game_x, in_game_y)
    map_object = $map[in_game_x, in_game_y]
    if map_object.is_a? BerryBush
      if $job_list.has?(CutBerryBushJob, map_object)
        job = $job_list.find(CutBerryBushJob, map_object)
        unless job.taken
          old_job = $job_list.delete(job)
          old_job.remove
        end
      else
        new_job = CutBerryBushJob.new(map_object)
        $job_list.add(new_job)
      end
    end

  end
end
