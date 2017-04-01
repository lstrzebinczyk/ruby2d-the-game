require 'ruby2d'
require 'perlin_noise'

require_relative "./items/item"
require_relative "./items/log"
require_relative "./items/berries"

require_relative "./map_elements/tree"
require_relative "./map_elements/logs_pile"
require_relative "./map_elements/berry_bush"
require_relative "./map_elements/berries_pile"

require_relative "./core_ext/time"
require_relative "./core_ext/integer"
require_relative "./core_ext/float"
require_relative "./core_ext/string"

require_relative "./actions/action_base"
require_relative "./actions/move_action"
require_relative "./actions/cut_tree_action"
require_relative "./actions/cut_berry_bush_action"
require_relative "./actions/pick_action"
require_relative "./actions/put_action"
require_relative "./actions/sleep_action"
require_relative "./actions/gather_berries_action"
require_relative "./actions/eat_action"

require_relative "./jobs/cut_tree_job"
require_relative "./jobs/cut_berry_bush_job"
require_relative "./jobs/carry_log_job"
require_relative "./jobs/pick_berry_bush_job"

require_relative "./structures/base"
require_relative "./structures/kitchen"
require_relative "./structures/fireplace"

require_relative "./game_modes/_index"

require_relative "./utils/pathfinder"
require_relative "./utils/grid"
require_relative "./utils/random_noise_generator"
require_relative "./utils/map"
require_relative "./utils/character"
require_relative "./utils/background"
require_relative "./utils/mouse_background_drawer"
require_relative "./utils/day_and_night_cycle"
require_relative "./utils/job_list"
require_relative "./utils/zones_list"

require_relative "./zones/storage_zone"

require_relative "./gui/fps_drawer"
require_relative "./gui/game_speed"
require_relative "./gui/inspection_menu"
require_relative "./gui/button"
require_relative "./gui/menu"

require_relative "./controls"
require_relative "./update"


# http://www.ruby2d.com/learn/reference/
PIXELS_PER_SQUARE = 16
SQUARES_WIDTH     = 60
SQUARES_HEIGHT    = 40

INSPECTION_MENU_WIDTH = 200

WORLD_WIDTH = PIXELS_PER_SQUARE * SQUARES_WIDTH
WIDTH  = WORLD_WIDTH + INSPECTION_MENU_WIDTH
WORLD_HEIGHT = PIXELS_PER_SQUARE * SQUARES_HEIGHT
MENU_HEIGHT = 5 * PIXELS_PER_SQUARE

INSPECTION_MENU_HEIGHT = WORLD_HEIGHT + MENU_HEIGHT

def rendered_objects
  (get :window).objects
end

set({
  title: "The Game Continues",
  width: WIDTH,
  height: WORLD_HEIGHT + MENU_HEIGHT,
  # diagnostics: true
})


# GAME SETUP
$characters_list = [
  Character.new(x: 30, y: 20, name: "Johann", type: :woodcutter),
  Character.new(x: 31, y: 20, name: "Franz", type: :woodcutter),
  Character.new(x: 31, y: 20, name: "Karl", type: :gatherer)

]
$map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
$background = Background.new

$fps_drawer = FpsDrawer.new
$mouse_background_drawer = MouseBackgroundDrawer.new
$menu = Menu.new
$day_and_night_cycle = DayAndNightCycle.new(WORLD_HEIGHT, WORLD_WIDTH)
$game_speed = GameSpeed.new
$job_list = JobList.new
$zones = ZonesList.new
$structures = [Fireplace.new]

$inspection_menu = InspectionMenu.new(INSPECTION_MENU_WIDTH, INSPECTION_MENU_HEIGHT, WORLD_WIDTH)

$previous_mouse_over = :game_window
$seconds_per_tick = 1 #0.25 Ideally I would like it to be 0.25, but that makes the game rather boring

$background.rerender
$characters_list.each(&:rerender)
$map.rerender
$structures.each(&:rerender)
$menu.rerender

fps = get(:fps)
$fps_drawer.rerender(fps)

$day_and_night_cycle.rerender
$inspection_menu.rerender


class GameWorld
  def self.things_at(x, y)
    arr = []
    arr << $map[x, y]
    arr << $zones[x, y]
    arr << $structures.find{|s| s.include_any?([[x, y]]) }
    arr.compact
  end
end



# 
# Autoplayer!
#

fireplace = $structures.find{|s| s.is_a? Fireplace }

# Designate storage place, 5x5 in size, above and to the right of fireplace
build_storage_mode = SetStorageGameMode.new
storage_top_left_x = fireplace.x + 2
storage_top_left_y = fireplace.y - 7

(storage_top_left_x..(storage_top_left_x+5)).each do |x|
  (storage_top_left_y..(storage_top_left_y+5)).each do |y|
    build_storage_mode.perform(x, y)
  end
end

# Cut whatever is in place of that storage mode

cut_game_mode = CutGameMode.new
designated_trees = []

$zones.each do |zone|
  if $map[zone.x, zone.y].is_a?(Tree)
    designated_trees.push($map[zone.x, zone.y])
  end
  cut_game_mode.perform(zone.x, zone.y)
end

trees_count = 20
if designated_trees.count < trees_count
  puts "need #{trees_count - designated_trees.count} more trees"

  need_more_trees_count = trees_count - designated_trees.count

  $map.find_all_closest_to(fireplace) do |map_element|
    map_element.is_a?(Tree) and !designated_trees.include?(map_element)
  end.take(need_more_trees_count).each do |tree|
    cut_game_mode.perform(tree.x, tree.y)
  end
end

# setup kitchen on first free spot closest to fireplace
build_kitchen_game_mode = BuildKitchenGameMode.new
all_spots = (0..SQUARES_WIDTH).to_a.product((0..SQUARES_HEIGHT).to_a)

free_spots = all_spots.keep_if do |arr|
  build_kitchen_game_mode.terrain_clear?(arr[0], arr[1])
end

free_spots.sort_by! do |a|
  (a[0] - fireplace.x).abs + (a[1] - fireplace.y).abs
end

spot = free_spots.first
build_kitchen_game_mode.perform(spot[0], spot[1])


kitchen = $structures.find{|s| s.is_a? Kitchen }

15.times do
  kitchen.ensure_more_berries
end

# START!
show



# SHOW A NICE ERROR MESSAGE IF THERE IS NO FILE IN IMAGE
# CREATE AN ISSUE ABOUT IMAGES NOT WORKING IN WEB VERSION

# http://karpathy.github.io/2015/05/21/rnn-effectiveness/
# ANDREJ KARPATHY LSTM

# LOOK CAREFULLY AT TENSORFLOW

# Look into neural networks to implement AI, what person wants to do ans so on

# LET THE SYSTEM USE SYSTEMS ARIAL BY DEFAULT?
# LET THE SYSTEM SHOW WHAT FONTS ARE AVAILABLE?

# RENDER WHAT PERSON HAS IN RIGHT AND LEFT HAND?
# ANIMATION WHEN THOSE TOOLS ARE USED? LIKE CHOPPING WOOD?
# ONLY ALLOW HAVING LEFT HAND AND RIGHT HAND FOR NOW

# Have menu options to choose between
  #   - dormitory 

# pre-calculate where passable areas are with flooding the map from characters position
# Use that information to help with maps passable information

# Then figure out logistics of building a house

# Maybe have queue of actions per person? Like: My main goal for now is to build a house
# But from time to time I have to stop it to sleep and eat
# But when I wake up, I want to get back to it

# With that introduce config file with all the informations that need to be setup
# like how long does it take to move, how fast do people get hungry and so on

# When that is done, look into having a settlement that is sentient
# And gives jobs to make itself functional

# Introduce drinking
# Introduce cooking

# have workbench for making wood things

# Have items like axes, fishing rods, waterskins and so on
# Organised crafting?
# Logging of various decisions people made/settlement requires?

# Prepare srug presentation?
# About all of this?

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

# BUG WHEN JOB IS GIVEN TO CUT TREE TO WHICH THERE IS NO PATH
# THE PATH IS ABANDONED, BUT TREE IS STILL CUT

# INTRODUCE SET OF UNIFIED SCENARIOS FOR PERFORMANCE BENCHMARKING
# INTRODUCE SOME TESTS?

# Introduce Game class, to be able to run tests without visual parts, and faster

# TODO: Introduce firewood
# TODO: cut Tree should leave logs and firewood
# TODO: cut bushes should leave firewood

# TT.......SS
# TT.......SS
# TT....C..SS
# TT.......SS
# TT.......SS
# UNIFIED BENCHMARK!
# HAVE A MAP LIKE THIS
# AND BENCHMARK TO CUT AND MOVE ALL THE TREES TO STORAGES

# TODO: DOING HARD WORK USES MORE ENERGY
# TODO: FOR EXAMPLE, PUTS YOU TO SLEEP FASTER

# TODO: Build a system of passing informations around 
# Instead of having all the informations in the system 
# People will use the informations they have themselves
# For example if there is food in the storage 
# or basically anything
# People go look for informations themselves
# Or can ask questions and get informations 
# Or people can exchange informations while just randomly talking

# TODO: 
# Implement a system of growing crops in a garden
# like tomatos, cucumbers and others
# Make it realistic
# Check how fast tomatos grow, how often do you need to water and so on 

# TODO: MIGRATE EVERYTHING FROM THE GAME V1
# TODO: Then replace the game v1 with current implementation 
# TODO: And have the new version accessible in github.io as web version

# TODO: HAVE GARDEN AND GROW BASIC GARDEN CROPS, 
#       FIGURE OUT WATERING DOWN AND HOW LONG DOES IT GROW

# TODO: HAVE CHICKENS, FIGURE OUT FEEDING THEM AND GETTING EGGS

# TODO: Have people have a base of knowledge
#       about their own belongings
#       for example: I have this-and-that in my own drawer


# TODO: CREATE CLI TO ADD THINGS LIKE 
#       - the_game create_action
#       - the_hame create_job
#       - etc


# TODO: ADD FISHERMAN
# TODO: ADD FARMER AND HIS CHICKENS

# TODO: Create map generator
# allow choosing of map before game


# TODO: MAKE THE MAP BIGGER
# TODO: ADD RIVER

# http://www.newhealthguide.org/How-Many-Calories-In-Salmon.html
# ŁOSOŚ: (atlantic salmon)
#   - 100g raw: 183 calories 
#   - 100g cooked: 206 calories

# TODO: JOB PRIORITISING
# TODO: Add progress bar as progressing circle when cutting trees and gathering bushes




# http://sosweetcreative.com/2613/font-face-and-base64-data-uri



# TODO: Bigger map 
# TODO: Buildable fireplace


# Create structures, assign people to them, and setup expectancies
#   - for example woodcutter workshop, assign woodcutter and set up to ensure n logs in storages 
#   - for example gatherer workshop, assign gatherer and assign n kilograms of berries in storages

# fuck gathering berries, create shop for autogatherying and 

# write ruby2d-autorequire
# Based on activesupport autorequiore
# but should work in all ruby2d modes


# Find and program some way to process berries into more caloric food
# http://www.se.pl/styl-zycia/przepisy-kulinarne/sezon-na-jagody_196021.html


# .......
# .......
# .......
# maybe....
# .......
# digging?
# .......
# in mountains?
# .......


# Js version, compile with emscripten?


# introduce global

# def sc(num)
#   num * PIXELS_PER_SQUARE
# end


# ??????


# Add game data inspection tab, let it have graph of rendered objects in time
# Might help find some rendered objects leak

# Kitchen should require some wood to be built
# Introduce "being built" structure state


# Introduce pottery!


# Implement inspection tab to list all available jobs in system



# TODO: Unify jobs interface, usage and behavior





# TODO: Characters start circulating aroung berries pile spot. Why?
# What went wrong?

# Use dwarf fortress mayday graphics set?

# TODO: Bug, people put piles on berries?
