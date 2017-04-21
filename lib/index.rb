require_relative "./game_world"
require_relative "./controls"
require_relative "./update"

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
    Character.new(x: 31, y: 20, name: "Franz", type: :fisherman),
    Character.new(x: 32, y: 20, name: "Karl", type: :gatherer),
    Character.new(x: 33, y: 20, name: "Joseph", type: :craftsman),
    Goat.new(34, 20)
  ]
  map = MapGenerator.new(SQUARES_WIDTH, SQUARES_HEIGHT).generate

  characters_list.each do |character|
    map.clear(character.x, character.y)
  end

  $game_world = GameWorld.new(characters_list, map)

  $structures << Fireplace.new

  $background = Background.new
  $fps_drawer = FpsDrawer.new
  $menu = Menu.new
  $inspection_menu = InspectionMenu.new(INSPECTION_MENU_WIDTH, INSPECTION_MENU_HEIGHT, WORLD_WIDTH)

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

class Autoplayer
  def initialize
    @done  = false
    @phase = 1
  end

  def build_phase_one
    cut_trees(5)
    gather_plants(10)
    set_storage
    set(Workshop)
    set(Kitchen)
    set(Fishery)

    @phase = 2
  end

  def perform!
    if @phase == 2
      if $structures.any?{|s| s.is_a? Workshop }
        workshop = $structures.find{|s| s.is_a? Workshop }
        3.times do
          workshop.request(Table)
        end
        3.times do
          workshop.request(Barrel)
        end
        3.times do
          workshop.request(Crate)
        end
        @phase += 1
      end
    end
  end

  private

  # TODO Make sure structure is at least 1 spot from any other structures and zones
  # Looks nicer :3
  # TODO: And at least 4 spots away from fireplace, or more
  def set(structure)
    fireplace = $structures.find{|s| s.is_a? Fireplace }

    build_workshop_game_mode = BuildGameMode.new(structure)
    all_spots = (0..SQUARES_WIDTH).to_a.product((0..SQUARES_HEIGHT).to_a)

    free_spots = all_spots.keep_if do |arr|
      build_workshop_game_mode.terrain_clear?(arr[0], arr[1])
    end

    free_spots.sort_by! do |a|
      (a[0] - fireplace.x).abs + (a[1] - fireplace.y).abs
    end

    spot = free_spots.first
    build_workshop_game_mode.perform(spot[0], spot[1])
  end

  def set_storage
    size = 6
    fireplace = $structures.find{|s| s.is_a? Fireplace }

    all_spots = (0..SQUARES_WIDTH).to_a.product((0..SQUARES_HEIGHT).to_a)
    free_spots = all_spots.find_all do |spot|
      x = spot[0]
      y = spot[1]
      (x..(x + size - 1)).to_a.product((y..(y + size - 1)).to_a).all? do |arr|
        $map.in_map?(arr[0], arr[1]) and GameWorld.things_at(arr[0], arr[1]).empty?
      end
    end

    closest_to_fireplace_spot = free_spots.sort_by! do |a|
      (a[0] - fireplace.x).abs + (a[1] - fireplace.y).abs
    end.first

    x_range = (closest_to_fireplace_spot[0]..(closest_to_fireplace_spot[0] + size - 1))
    y_range = (closest_to_fireplace_spot[1]..(closest_to_fireplace_spot[1] + size - 1))

    SetStorageGameMode.new.perform(x_range, y_range)
  end

  def cut_trees(count)
    fireplace = $structures.find{|s| s.is_a? Fireplace }
    cut_game_mode = CutGameMode.new
    designated_trees = []

    count.times do
      tree = $map.find_closest_to(fireplace) do |map_element|
        map_element.is_a?(Tree) and !designated_trees.include?(map_element)
      end
      designated_trees.push(tree)
      cut_game_mode.perform((tree.x..tree.x), (tree.y..tree.y))
    end
  end

  def gather_plants(count)
    fireplace = $structures.find{|s| s.is_a? Fireplace }
    cut_game_mode = GatherGameMode.new
    designated_bushes = []

    count.times do
      bush = $map.find_closest_to(fireplace) do |map_element|
        map_element.is_a?(BerryBush) and !designated_bushes.include?(map_element)
      end
      designated_bushes.push(bush)
      cut_game_mode.perform((bush.x..bush.x), (bush.y..bush.y))
    end
  end
end

@autoplay = true
if @autoplay
  $autoplayer = Autoplayer.new
  $autoplayer.build_phase_one
end


# START!
show

# TODO:
# Think about having someting like n.+(other, modulo) functions. This will perform modulo adding.
# This should be really fast, because no checking is needed for overflow if module is small enough

# 2d top view rune clone? In which you walk and control your character from the top and fight other people?
# Warhammer game?


# http://gameprogrammingpatterns.com/game-loop.html

# Should jobs or actions be implemented as enumerator?


# Having a simulation where you can watch city being build is one idea
# Other is: build the city yourself, like a designer
# Fill it with actors that do their own job, each one has their role to fill
#   their own needs etc

# - Introduce some sort of adventure, reality to it
# - and allow player inside, let him do things

# - Kontrakt oldenhallera?
# - Kreutzhoffen !!!!!!
#   - Oh I love that place

# Implement some nice system to find out where and when no path error happens

# Prepare presentation about ruby2d and the game
  # - write simple space invader?

# Write a PR with removing events!
# I need this to provide nice menu for structures

# Talk to Witold and Mike about AC sponsoring the next srug

# Try creating initial version of warhammer?

# Observable based visual things? Sort of based on ember ?
# This could help having menu reorganised only when needed
