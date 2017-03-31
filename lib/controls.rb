on(mouse: 'any') do |x, y, thing|
  # puts "#{x} #{y} #{thing}"
  # Only take consider user action if it clicks on map
  # not if it clicks on menu
  if $menu.contains?(x, y)
    $menu.click(x, y)
  elsif $inspection_menu.contains?(x, y)
    $inspection_menu.click(x, y)
  else
    $menu.game_mode.click(x, y)
  end
end

on key_down: "space" do
  if @paused
    $game_speed.set(@previous_game_speed)
    @previous_game_speed = nil
    @paused = nil
  else
    @previous_game_speed = $game_speed.value
    $game_speed.set(0)
    @paused = true
  end
end

on key_down: "escape" do 
  close
end

on_key do |key|
  if key == "1"
    $game_speed.set(1)
  end

  if key == "2"
    $game_speed.set(5)
  end

  if key == "3"
    $game_speed.set(100)
  end

  if key == "4"
    $game_speed.set(250)
  end

  if key == "5"
    $game_speed.set(1000)
  end

  if key == "q"
    p $job_list
  end

  if key == "p"
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

  if key == "o"
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
