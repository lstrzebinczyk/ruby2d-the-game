class CutTreesGameMode
  def click(x, y)
    in_game_x = x / PIXELS_PER_SQUARE
    in_game_y = y / PIXELS_PER_SQUARE

    map_object = $map[in_game_x, in_game_y]
    if map_object.is_a? Tree
      new_job = CutTreeJob.new(map_object)

      # Do not queue this same job multiple times, for example do not add
      # the same tree to be cut 2 times
      if $job_list.has?(new_job)
        new_job.remove
      else
        $job_list.add(new_job)
      end
    end
  end
end
