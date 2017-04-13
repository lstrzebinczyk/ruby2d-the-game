update do
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
