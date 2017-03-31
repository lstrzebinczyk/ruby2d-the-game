update do 
  # Only show mouse button if it's on map
  # don't show anything if it's on menu
  if $menu.contains?(get(:mouse_x), get(:mouse_y))
    if $previous_mouse_over == :menu
      $menu.unhover
    elsif $previous_mouse_over == :game_window
      $menu.game_mode.unhover()
      $previous_mouse_over = :menu
    end
    $menu.hover(get(:mouse_x), get(:mouse_y))
  else
    if $previous_mouse_over == :menu
      $menu.unhover
      $previous_mouse_over = :game_window
    elsif $previous_mouse_over == :game_window
      $menu.game_mode.unhover()
    end
    mouse_x = (get(:mouse_x) / PIXELS_PER_SQUARE)
    mouse_y = (get(:mouse_y) / PIXELS_PER_SQUARE)
    $menu.game_mode.hover(mouse_x, mouse_y)
  end

  # APPROXIMATELY 2 times per second
  if rand < 0.03
    fps = get(:fps)
    $fps_drawer.rerender(fps)
  end

  $game_speed.value.times do
    $characters_list.each do |character|
      unless character.has_action?
        if character.needs_own_action?
          character.set_own_action
        else

          # TODO: Character should refuse to take action
          # TODO: If his mood is too bad, for example too sleepy and too hungry to work

          job = $job_list.get_job
          if job
            action = job.action_for(character)
            character.action = action
            job.taken = true
          end
        end
      end
      character.update($seconds_per_tick)
    end

    $day_and_night_cycle.update
  end

  $inspection_menu.rerender_progress_bars
  $fireplace.update($day_and_night_cycle.time)
end
