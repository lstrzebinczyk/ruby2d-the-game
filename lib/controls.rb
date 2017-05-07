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

on :mouse_down do |e|
  if e.button == :right
    $menu.game_mode.abort
  end
end

$flood_map_rendered = false

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
    if $flood_map_rendered
      $flood_map_rendered.each(&:remove)
      $flood_map_rendered = nil
    else
      $flood_map_rendered = []
      (0...SQUARES_WIDTH).each do |x|
        (0...SQUARES_HEIGHT).each do |y|
          map_spot = $map[x, y]
          if map_spot.available == :ok
            renderer = MapRenderer.square(x, y, 1, "green")
            rendered.color.opacity = 0.2
            $flood_map_rendered << rendered
          elsif map_spot.available
            renderer = MapRenderer.square(x, y, 1, "fuchsia")
            rendered.color.opacity = 0.8
            $flood_map_rendered << rendered
          end
        end
      end
    end
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
  when "w"
    $map_position.offset_y += 4 * PIXELS_PER_SQUARE
  when "s"
    $map_position.offset_y -= 4 * PIXELS_PER_SQUARE
  when "a"
    $map_position.offset_x += 4 * PIXELS_PER_SQUARE
  when "d"
    $map_position.offset_x -= 4 * PIXELS_PER_SQUARE
  end
end

def toggle_profiling_cpu
  if $profiling
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
    $profiling = true
  end
end

on :key_down do |e|
  if e.key == "p"
    toggle_profiling_cpu
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
