on :mouse_move do |e|
  $menu.game_mode.unhover
  if e.x < WORLD_WIDTH and e.y < WORLD_HEIGHT
    $menu.game_mode.hover(e.x / PIXELS_PER_SQUARE, e.y / PIXELS_PER_SQUARE)
  else
    $menu.game_mode.abort
  end
end

on :mouse_down do |e|
  if e.x < WORLD_WIDTH and e.y < WORLD_HEIGHT and e.button == :left
    $menu.game_mode.mouse_down(e.x, e.y)
  end
end

on :mouse_up do |e|
  if e.x < WORLD_WIDTH and e.y < WORLD_HEIGHT and e.button == :left
    $menu.game_mode.mouse_up(e.x, e.y)
  end
end

on :key_down do |e|
  case e.key
  when "space"
    if @paused
      $game_speed.set(@previous_game_speed)
      @previous_game_speed = nil
      @paused = nil
    else
      @previous_game_speed = $game_speed.value
      $game_speed.set(0)
      @paused = true
    end
  when "escape"
    close
  when "f5"
    get(:window).clear
    start_game!
  when "z"
    $flood_map && $flood_map.toggle
  when "1"
    $game_speed.set(1)
  when "2"
    $game_speed.set(5)
  when "3"
    $game_speed.set(100)
  when "4"
    $game_speed.set(250)
  when "5"
    $game_speed.set(1000)
  end
end

on :key_down do |e|
  if e.key == "l"
    workshop = $structures.find{|s| s.is_a? Workshop }

    if workshop
      workshop.request(Table)
      $inspection_menu.rerender_content
    end
  end

  if e.key == "k"
    workshop = $structures.find{|s| s.is_a? Workshop }

    if workshop
      workshop.request(Barrel)
      $inspection_menu.rerender_content
    end
  end
end

on :key_down do |e|
  if e.key == "p"
    if @profiling
      result = RubyProf.stop
      printer = RubyProf::GraphHtmlPrinter.new(result)

      Pathname.new(FileUtils.pwd).join("./profiles/in-game.html").open("w+") do |file|
        printer.print(file, {})
      end
      close
    else
      Text.new(200, 15, "PROFILING CPU", 40, "fonts/arial.ttf")

      require "ruby-prof"
      require "pathname"

      RubyProf.start
      @profiling = true
    end
  end
end

on :key_down do |e|
  if e.key == "o"
    if @profiling
      result = RubyProf.stop
      printer = RubyProf::GraphHtmlPrinter.new(result)

      Pathname.new(FileUtils.pwd).join("./profiles/in-game-allocations.html").open("w+") do |file|
        printer.print(file, {})
      end
      close
    else
      Text.new(200, 15, "PROFILING MEMORY", 40, "fonts/arial.ttf")
      require "ruby-prof"
      require "pathname"

      RubyProf.measure_mode = RubyProf::ALLOCATIONS
      RubyProf.start
      @profiling = true
    end
  end
end
