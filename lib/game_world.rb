require 'ruby2d'
require 'perlin_noise'

require_relative "./items/item"
require_relative "./items/log"
require_relative "./items/berries"

require_relative "./map_elements/tree"
require_relative "./map_elements/logs_pile"
require_relative "./map_elements/berry_bush"
require_relative "./map_elements/berries_pile"
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
require_relative "./actions/gather_berries_action"
require_relative "./actions/eat_action"

require_relative "./jobs/cut_tree_job"
require_relative "./jobs/cut_berry_bush_job"
require_relative "./jobs/carry_log_job"
require_relative "./jobs/pick_berry_bush_job"
require_relative "./jobs/eat_job"
require_relative "./jobs/sleep_job"

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
require_relative "./utils/day_and_night_cycle"
require_relative "./utils/job_list"
require_relative "./utils/zones_list"
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
    arr << $zones[x, y]
    arr << $structures.find{|s| s.include_any?([[x, y]]) }
    arr << $characters_list.find_all{|char| char.x == x and char.y == y }
    arr.flatten.compact
  end

  def initialize(characters_list, map)
    $seconds_per_tick    = 1 #0.25 Ideally I would like it to be 0.25, but that makes the game rather boring
    $characters_list     = characters_list
    $map                 = map
    $day_and_night_cycle = DayAndNightCycle.new(WORLD_HEIGHT, WORLD_WIDTH)
    $game_speed          = GameSpeed.new
    $job_list            = JobList.new
    $zones               = ZonesList.new
    $structures          = []
    $flood_map           = FloodMap.new(map, characters_list)
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
        end
        character.update($seconds_per_tick)
      end

      $day_and_night_cycle.update
    end

    $structures.each do |structure|
      structure.update($day_and_night_cycle.time)
    end
  end
end
