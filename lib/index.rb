require_relative "./game_world"
require_relative "./controls"
require_relative "./update"

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

characters_list = [
  Character.new(x: 30, y: 20, name: "Johann", type: :woodcutter),
  Character.new(x: 31, y: 20, name: "Franz", type: :woodcutter),
  Character.new(x: 31, y: 20, name: "Karl", type: :gatherer)
]
map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
map.fill_grid_with_objects

$game_world = GameWorld.new(characters_list, map)

$structures << Fireplace.new

$background = Background.new
$fps_drawer = FpsDrawer.new
$menu = Menu.new
$inspection_menu = InspectionMenu.new(INSPECTION_MENU_WIDTH, INSPECTION_MENU_HEIGHT, WORLD_WIDTH)

$previous_mouse_over = :game_window

$background.rerender
$characters_list.each(&:rerender)
$map.rerender
$structures.each(&:rerender)
$menu.rerender

fps = get(:fps)
$fps_drawer.rerender(fps)

$inspection_menu.rerender
$day_and_night_cycle.rerender

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

# http://sosweetcreative.com/2613/font-face-and-base64-data-uri



# TODO: Bigger map
# TODO: Buildable fireplace


# Create structures, assign people to them, and setup expectancies
#   - for example woodcutter workshop, assign woodcutter and set up to ensure n logs in storages

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

# Add game data inspection tab, let it have graph of rendered objects in time
# Might help find some rendered objects leak

# Kitchen should require some wood to be built
# Introduce "being built" structure state


# Introduce pottery!


# Implement inspection tab to list all available jobs in system

# TODO: Unify jobs interface, usage and behavior


# Use dwarf fortress mayday graphics set?

# TODO: Bug, people put piles on berries?
# TODO: Finish map builder and first set of tests

# TODO: Implement death of starvation
# TODO: So that our tests of various scenarios are somewhat realistic

# TODO: Write tests to measure effects of various things
# TODO: So that we can measure effect of various things
# for example how many iterations it takes to cut n trees with fireplace, and how many without fireplace


# TODO: WRITE SPECIALISED TESTS FOR JOBS and game modes

# TODO: Implement own time class, current one is sloooooow

# TODO: day_and_night_cycle should be 2 separate classess, one for time and one for mask


# Extract Button class to a nice external lib
# ruby2d-button

# Based more-or-less on html version of button
# To have nice and self-contained buttons we must have the ability to add multiple on_click events
# , an array of them


# TODO: Implement store action: we should only look for place to story things when we have it
# in our hands and we want to go to a place

# Looking for a place to store when we create the issue is pointless, because we are likely going to
# have to do it again


# TODO: PEOPLE MORE OR LESS know how hungry they are. PEople should get enough food from storage to get fed
# TODO: Actions should only be producable inside jobs
# with action builder


# Bug, why they keep pushing logs to where berries pile is...?
