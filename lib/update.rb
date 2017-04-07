update do
  # GUI

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
  elsif $inspection_menu.contains?(get(:mouse_x), get(:mouse_y))
    $menu.game_mode.unhover()
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

  $inspection_menu.rerender_content

  # APPROXIMATELY 2 times per second
  if rand < 0.03
    fps = get(:fps)
    $fps_drawer.rerender(fps)
  end


  # GAME WORLD
  $game_world.update

  # 8.times do
  #   if $start_flood_map_progressing
  #     $flood_map && $flood_map.progress
  #   end
  # end
end
