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

def start_game!
  characters_list = [
    Character.new(x: 30, y: 20, name: "Johann", type: :woodcutter),
    Character.new(x: 31, y: 20, name: "Franz", type: :woodcutter),
    Character.new(x: 32, y: 20, name: "Karl", type: :gatherer),
    Character.new(x: 33, y: 20, name: "Joseph", type: :craftsman),
  ]
  map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
  map.fill_grid_with_objects
  characters_list.each do |character|
    map.clear(character.x, character.y)
  end

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
end

start_game!

#
# Autoplayer!
#

# @autoplay = true
if @autoplay

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

  trees_count = 5
  if designated_trees.count < trees_count
    puts "need #{trees_count - designated_trees.count} more trees"

    need_more_trees_count = trees_count - designated_trees.count

    need_more_trees_count.times do
      tree = $map.find_closest_to(fireplace) do |map_element|
        map_element.is_a?(Tree) and !designated_trees.include?(map_element)
      end
      designated_trees.push(tree)
      cut_game_mode.perform(tree.x, tree.y)
    end
  end

  # setup kitchen on first free spot closest to fireplace
  # build_kitchen_game_mode = BuildKitchenGameMode.new
  # all_spots = (0..SQUARES_WIDTH).to_a.product((0..SQUARES_HEIGHT).to_a)

  # free_spots = all_spots.keep_if do |arr|
  #   build_kitchen_game_mode.terrain_clear?(arr[0], arr[1])
  # end

  # free_spots.sort_by! do |a|
  #   (a[0] - fireplace.x).abs + (a[1] - fireplace.y).abs
  # end

  # spot = free_spots.first
  # build_kitchen_game_mode.perform(spot[0], spot[1])


  # kitchen = $structures.find{|s| s.is_a? Kitchen }

  # 15.times do
  #   kitchen.ensure_more_berries
  # end
end

# START!
show

# TODO:
# Think about having someting like n.+(other, modulo) functions. This will perform modulo adding.
# This should be really fast, because no checking is needed for overflow if module is small enough

# 2d top view rune clone? In which you walk and control your character from the top and fight other people?
# Warhammer game?

# IMplement that flood map that will, for all map positions, store if that position is achievable or not
# Cut/remove tasks are only available when they are on achievable spots
# flood map is updated on each putting something on map and each removing something from map
# unify putting and removing something from map
# when removing something, that field becomes achievable if any neighbor is achievable
# when adding something, figure out smart thing to do

# Also instead of "carry job" implement "store job". Store job will look for available zone on start
# and only be available when there is an available zone empty or with proper type

# Then we can make tests map compact again

# http://gameprogrammingpatterns.com/game-loop.html

# Should jobs or actions be implemented as enumerator?


# TODO WITH WOODEN WORKSHOP:
# - have kitchen require a table to build in the same manner workshop requires piece of wood

# - then a fishing workshop, require a table too


# http://www-cs-students.stanford.edu/~amitp/game-programming/polygon-map-generation

# TODO: PUT ACTION SHOULD NOT BE ONLY FOR LOGS
# TODO: Supplying things to workshop sometimes teleports
# TODO: Write test for creating workshop and producing a table


# Having a simulation where you can watch city being build is one idea
# Other is: build the city yourself, like a designer
# Fill it with actors that do their own job, each one has their role to fill
#   their own needs etc

# - Introduce some sort of adventure, reality to it
# - and allow player inside, let him do things

# - Kontrakt oldenhallera?
# - Kreutzhoffen !!!!!!
#   - Oh I love that place



# DIRECTIONS = [
#   [ 1,  0],
#   [ 0,  1],
#   [-1,  0],
#   [ 0, -1]
# ]

# def square_edge_coordinates((center_x, center_y), radius)
#   position = [center_x - radius/2, center_y - radius/2]

#   DIRECTIONS.lazy
#     .flat_map do |direction|
#       [direction].lazy
#         .cycle
#         .take(radius.pred)
#     end
#     .map do |step|
#       old_position = position

#       position = position.zip(step).map(&:sum) # elementwise vector sum

#       old_position
#     end
# end

# def range(x=Float::INFINITY)
#   (0...x).lazy
# end

# def odd_numbers
#   range.map { |x| 1 + 2 * x }
# end

# def search_path(center)
#   odd_numbers
#     .drop(1).
#     .flat_map { |radius| square_edge_coordinates(center, radius) }
# end

# square_edge_coordinates([10, 10], 5).force.to_a
