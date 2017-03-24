# If there is already a job in queue, and it's not taken, remove it 
# If it's taken, don't do anything
# If there is none, add job

class CutTreesGameMode
  def click(x, y)
    in_game_x = x / PIXELS_PER_SQUARE
    in_game_y = y / PIXELS_PER_SQUARE

    map_object = $map[in_game_x, in_game_y]
    if map_object.is_a? Tree
      if $job_list.has?(CutTreeJob, map_object)
        job = $job_list.find(CutTreeJob, map_object)
        unless job.taken
          old_job = $job_list.delete(job)
          old_job.remove
        end
      else
        new_job = CutTreeJob.new(map_object)
        $job_list.add(new_job)
      end
    end
  end
end
