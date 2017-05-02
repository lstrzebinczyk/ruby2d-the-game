require "observer"

require 'ruby2d'
require 'perlin_noise'

require "active_support"
require "active_support/dependencies"

require_relative "./core_ext/float"
require_relative "./core_ext/integer"
require_relative "./core_ext/string"
require_relative "./core_ext/time"

ActiveSupport::Dependencies.autoload_paths += %w[
  lib/actions
  lib/creatures
  lib/game_modes
  lib/gui
  lib/items
  lib/jobs
  lib/map_elements
  lib/structures
  lib/utils
  lib/zones
  lib/constructions
]

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
    if $map[x, y]
      arr = []
      arr << $map[x, y].content
      arr << $map[x, y].terrain unless $map[x, y].terrain.passable?
      arr << $zones.find_all{|s| s.include_any?([[x, y]]) }
      arr << $structures.find_all{|s| s.include_any?([[x, y]]) }
      arr << $characters_list.find_all{|char| char.x == x and char.y == y }
      arr << $creatures_list.find_all{|creature| creature.x == x and creature.y == y }
      arr.flatten.compact
    else
      []
    end
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
    $constructions       = []

    $map.calculate_availability($characters_list)
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
        unless creature.has_action?
          if creature.needs_own_action?
            creature.set_own_action
          end

          creature.chill unless creature.job
        end
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
