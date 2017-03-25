require 'ruby2d'
require 'perlin_noise'

require_relative "./items/log"

require_relative "./map_elements/tree"
require_relative "./map_elements/logs_pile"

require_relative "./core_ext/time"

require_relative "./actions/action_base"
require_relative "./actions/move_action"
require_relative "./actions/cut_tree_action"
require_relative "./actions/pick_action"
require_relative "./actions/put_action"

require_relative "./jobs/cut_tree_job"
require_relative "./jobs/carry_log_job"

require_relative "./utils/pathfinder"
require_relative "./utils/grid"
require_relative "./utils/random_noise_generator"
require_relative "./utils/map"
require_relative "./utils/character"
require_relative "./utils/background"
require_relative "./utils/mouse_background_drawer"
require_relative "./utils/day_and_night_cycle"
require_relative "./utils/fireplace"
require_relative "./utils/job_list"
require_relative "./utils/menu"
require_relative "./utils/zones_list"

require_relative "./zones/storage_zone"

require_relative "./game_modes/cut_trees_game_mode"
require_relative "./game_modes/do_nothing_game_mode"
require_relative "./game_modes/build_storage_mode"

require_relative "./gui/fps_drawer"
require_relative "./gui/game_speed"

# http://www.ruby2d.com/learn/reference/
PIXELS_PER_SQUARE = 16
SQUARES_WIDTH     = 60
SQUARES_HEIGHT    = 40
WIDTH  = PIXELS_PER_SQUARE * SQUARES_WIDTH
WORLD_HEIGHT = PIXELS_PER_SQUARE * SQUARES_HEIGHT
MENU_HEIGHT = 5 * PIXELS_PER_SQUARE

# PROFIDE DEFAULT FONT?
# SHOW A NICE ERROR MESSAGE IF THERE IS NO FILE IN IMAGE
# YIELD TICK NUMBER TO AN UPDATE?
# CREATE AN ISSUE ABOUT IMAGES NOT WORKING IN WEB VERSION
# LAY DOWN BUSHES (OF LOVE)

# http://karpathy.github.io/2015/05/21/rnn-effectiveness/
# ANDREJ KARPATHY LSTM

# LOOK CAREFULLY AT TENSORFLOW

# Look into neural networks to implement AI, what person wants to do ans so on

# LET THE SYSTEM USE SYSTEMS ARIAL BY DEFAULT?
# LET THE SYSTEM SHOW WHAT FONTS ARE AVAILABLE?

# RENDER WHAT PERSON HAS IN RIGHT AND LEFT HAND?
# ANIMATION WHEN THOSE TOOLS ARE USED? LIKE CHOPPING WOOD?
# ONLY ALLOW HAVING LEFT HAND AND RIGHT HAND FOR NOW

# ONLY RENDERING METHODS SHOULD BE CONCERNED WITH PIXELS PER SQUARE
# REST SHOULD ONLY HANDLE ABOUT IN-GAME POSITION

# ALLOW ME, A USER, TO INSPECT A LIST OF ALL RENDERED ITEMS
# FOR DEBUGGING REASONS AT LEAST?

def rendered_objects
  (get :window).objects
end

set({
  title: "The Game Continues",
  width: WIDTH,
  height: WORLD_HEIGHT + MENU_HEIGHT,
  # diagnostics: true
})

$map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
$background = Background.new

$map.clear(30, 20) # Make sure there is nothing but the character at this position
$character = Character.new(30, 20)

$fps_drawer = FpsDrawer.new
$mouse_background_drawer = MouseBackgroundDrawer.new
$menu = Menu.new
$day_and_night_cycle = DayAndNightCycle.new(WORLD_HEIGHT)
$game_speed = GameSpeed.new
$fireplace = Fireplace.new
$job_list = JobList.new
$zones = ZonesList.new

@tick = 0
def update_with_tick(&block)
  update do
    block.call(@tick)
    @tick = (@tick + 1) % 60
  end
end

$previous_mouse_over = :game_window

update_with_tick do |tick|
  mouse_x = (get(:mouse_x) / PIXELS_PER_SQUARE)
  mouse_y = (get(:mouse_y) / PIXELS_PER_SQUARE)

  # Only show mouse button if it's on map
  # don't show anything if it's on menu
  # $mouse_background_drawer.remove
  if $menu.contains?(get(:mouse_x), get(:mouse_y))
    if $previous_mouse_over == :menu
      $menu.unhover
    elsif $previous_mouse_over == :game_window
      $mouse_background_drawer.remove
      $previous_mouse_over = :menu
    end
    $menu.hover(get(:mouse_x), get(:mouse_y))
  else
    if $previous_mouse_over == :menu
      $menu.unhover
      $previous_mouse_over = :game_window
    elsif $previous_mouse_over == :game_window
      $mouse_background_drawer.remove
    end
    $mouse_background_drawer.render(mouse_x, mouse_y)
  end

  if tick % 30 == 0
    fps = get(:fps)
    $fps_drawer.rerender(fps)
  end

  $game_speed.value.times do
    if $character.has_action?
      $character.update
    else
      job = $job_list.get_job
      if job
        action = job.action_for($character)
        $character.action = action
        job.taken = true
      end
    end

    $day_and_night_cycle.update
  end

  $fireplace.update($day_and_night_cycle.time)
end

# CLEANUP

# Have menu options to choose between
  #   - dormitory ? next step, we need sleeping for that

# pre-calculate where passable areas are with flooding the map from characters position
# Use that information to help with maps passable information

# Then figure out logistics of building a house

# Maybe have queue of actions per person? Like: My main goal for now is to build a house
# But from time to time I have to stop it to sleep and eat
# But when I wake up, I want to get back to it

# With that introduce config file with all the informations that need to be setup
# like how long does it take to move, how fast do people get hungry and so on

# When creating buildings is ready, look into feeding people.
# When that is done, look into having a settlement that is sentient
# And gives jobs to make itself functional

# Introduce drinking
# Introduce cooking
# Introduce people types, accepting various jobs, or prioritising varous jobs
# Introduce berry bush gathering
# Maybe have the settlement require a stockpile, and in that stockpile a specific amount of food and wood?
# With that stockpile have barrels, boxes and saxes for things?

# have workbench for making wood things

# Have items like axes, fishing rods, waterskins and so on
# Organised crafting?
# Logging of various decisions people made/settlement requires?

# REMOVABLE MODULE TO UNIFY MAP BEHAVIOR? ADDING AND REMOVING TO RENDER BEHAVIOR?
# RENDERABLE MODULE?

# TALK ABOUT INTRODUCING EXPLICIT Z-INDEX TO RENDERED THINGS?

# ONMAP module, that makes sure element implements #passable?
# RUN TESTS, MAKE SURE ALL REQUIRED METHODS ARE THERE

# Start writing tests for those corner cases we are starting to pile up

# **********************************
# You have many things now!
# Start working on giving back to community!
# You stared issues on github, help solving them!
# ***********************************

# TODO
# Introduce realistic time passing?
# Make gametime events be as realistic as possible ?

# Prepare srug presentation?
# About all of this?

# introduce sleeping

# FONT IN WEB VERSION DOES NOT RENDER IN PROPER SIZE

# GET WIDTH FROM TEXT?
# To build something around it?

# INTRODUCE N CHARACTERS

# Introduce roads
# when person goes to road it's noted
# and when there is enough of those 
# road (in steps) is created
# it should be easier to walk on road 
# (smaller cost)
# thus reinforcing roads creation

# Random visitors should visit city 
# and want to eat something and stay for a night 
# and want to leave money
# later this should be only near trade routes
# or on crossing of trade routes

# later there should be various kind of cities with various
# interesting things

# Check The Sims on statistics for how peoples needs change in time
# Like sleeping, eating and so on
# Aw man, there is a lot of good stuff in sims wiki pages

# Write documentation? For myself and others, to inform what various concepts are?
# Add right menu with tabs:
  # - show jobs list 
  # - show characters

# I want one my second to be 4 seconds of world time
# DO I???

# BUG WHEN JOB IS GIVEN TO CUT TREE TO WHICH THERE IS NO PATH
# THE PATH IS ABANDONED, BUT TREE IS STILL CUT

on(mouse: 'any') do |x, y, thing|
  # puts "#{x} #{y} #{thing}"
  # Only take consider user action if it clicks on map
  # not if it clicks on menu
  if $menu.contains?(x, y)
    $menu.click(x, y)
  else
    $menu.game_mode.click(x, y)
  end
end

on_key do |key|
  if key == "escape"
    puts "pressed key: #{key}"
    close
  end

  if key == key.to_i.to_s
    if key == "0"
      game_speed = 0
    else
      game_speed = 2 ** (key.to_i - 1)
    end
    $game_speed.set(game_speed)
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
      require "ruby-prof"
      require "pathname"

      RubyProf.start
      @profiling = true
    end
  end
end

# TODO: This is a problem
# ensure that once rendered elements are in proper Z-INDEX
# and that they dont need to be rerendered in order
# to be seen at all

# think of better system to work with this

$background.rerender
$character.rerender
$map.rerender
$fireplace.rerender
$menu.rerender

show



# IMPLEMENT WRAPPER OVER RENDERING WITH Z-INDEX FEATURE
# THAN SUGGEST IT TO THE GUY


# INTRODUCE SET OF UNIFIED SCENARIOS FOR PERFORMANCE BENCHMARKING
# INTRODUCE SOME TESTS?
