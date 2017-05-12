update do
  $inspection_menu.rerender_content

  # APPROXIMATELY 2 times per second
  if rand < 0.03
    fps = get(:fps)
    $fps_drawer.rerender(fps)
  end

  $game_world.update
end
