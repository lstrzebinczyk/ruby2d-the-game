require 'ruby2d'
require 'perlin_noise'

require_relative "./items/item"
require_relative "./items/log"
require_relative "./items/berries"
require_relative "./items/table"
require_relative "./items/barrel"
require_relative "./items/crate"
require_relative "./items/raw_fish"
require_relative "./items/cleaned_fish"
require_relative "./items/cooked_fish"

require_relative "./map_elements/tree"
require_relative "./map_elements/berry_bush"
require_relative "./map_elements/river"

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
require_relative "./actions/gather_action"
require_relative "./actions/eat_action"
require_relative "./actions/supply_action"
require_relative "./actions/build_action"
require_relative "./actions/produce_action"
require_relative "./actions/chill_action"
require_relative "./actions/get_action"
require_relative "./actions/fish_action"

require_relative "./jobs/cut_tree_job"
require_relative "./jobs/cut_berry_bush_job"
require_relative "./jobs/eat_job"
require_relative "./jobs/sleep_job"
require_relative "./jobs/supply_job"
require_relative "./jobs/build_job"
require_relative "./jobs/produce_job"
require_relative "./jobs/store_job"
require_relative "./jobs/chill_job"
require_relative "./jobs/gather_job"
require_relative "./jobs/fishing_job"

require_relative "./structures/base"
require_relative "./structures/_blueprint"
require_relative "./structures/_construction"
require_relative "./structures/kitchen"
require_relative "./structures/fireplace"
require_relative "./structures/workshop"
require_relative "./structures/fishery"

require_relative "./game_modes/_index"

require_relative "./creatures/creature"
require_relative "./creatures/goat"
require_relative "./creatures/character"

require_relative "./utils/pathfinder"
require_relative "./utils/grid"
require_relative "./utils/random_noise_generator"
require_relative "./utils/map"
require_relative "./utils/map_generator"
require_relative "./utils/background"
require_relative "./utils/day_and_night_cycle"
require_relative "./utils/job_list"
require_relative "./utils/flood_map"

require_relative "./zones/storage_zone"

require_relative "./gui/fps_drawer"
require_relative "./gui/game_speed"
require_relative "./gui/inspection_menu"
require_relative "./gui/button"
require_relative "./gui/menu"
require_relative "./gui/mouse_background_drawer"

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

class GameWorld
  def self.things_at(x, y)
    arr = []
    arr << $map[x, y]
    arr << $zones.find_all{|s| s.include_any?([[x, y]]) }
    arr << $structures.find_all{|s| s.include_any?([[x, y]]) }
    arr << $characters_list.find_all{|char| char.x == x and char.y == y }
    arr.flatten.compact
  end

  def initialize(opts)
    $seconds_per_tick    = 1 #0.25 Ideally I would like it to be 0.25, but that makes the game rather boring
    $characters_list     = opts[:characters_list]
    $map                 = opts[:map]
    $creatures_list      = opts[:creatures_list]
    $day_and_night_cycle = DayAndNightCycle.new(WORLD_HEIGHT, WORLD_WIDTH)
    $game_speed          = GameSpeed.new
    $job_list            = JobList.new
    $zones               = []
    $structures          = []
    $flood_map           = FloodMap.new($map, $characters_list)
  end

  def update
    $game_speed.value.times do
      $characters_list.each do |character|
        unless character.has_action?
          if character.needs_own_action?
            character.set_own_action
          else
            # TODO: Character should refuse to take action
            # TODO: If his mood is too bad, for example too sleepy and too hungry to work
            character.job = $job_list.get_job(character)
          end

          character.chill unless character.job
        end
        character.update($seconds_per_tick)
      end

      $creatures_list.each do |creature|
        creature.chill unless creature.job
        creature.update($seconds_per_tick)
      end

      $day_and_night_cycle.update
    end

    $structures.each do |structure|
      structure.update($day_and_night_cycle.time)
    end

    $autoplayer.perform! if $autoplayer
  end
end
