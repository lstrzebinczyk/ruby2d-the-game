require 'ruby2d'

require_relative "./actions/move_action"

require_relative "./utils/pathfinder"
require_relative "./utils/map"
require_relative "./utils/character"
require_relative "./utils/path"
require_relative "./utils/tree"
require_relative "./utils/background"
require_relative "./utils/action_point"
require_relative "./utils/fps_drawer"
require_relative "./utils/mouse_background_drawer"
require_relative "./utils/day_and_night_cycle"
require_relative "./utils/game_speed"

# http://www.ruby2d.com/learn/reference/
PIXELS_PER_SQUARE = 16
SQUARES_WIDTH     = 60
SQUARES_HEIGHT    = 40
WIDTH  = PIXELS_PER_SQUARE * SQUARES_WIDTH
HEIGHT = PIXELS_PER_SQUARE * SQUARES_HEIGHT

# PROFIDE DEFAULT FONT?
# SHOW A NICE ERROR MESSAGE IF THERE IS NO FILE IN IMAGE
# YIELD TICK NUMBER TO AN UPDATE?
# USE SPRITE? OR BIGGER PICTURE?
# ADD EXITING ON ESCAPE
# CREATE AN ISSUE ABOUT IMAGES NOT WORKING IN WEB VERSION
# LAY DOWN TREES AND BUSHES (OF LOVE)

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

# BUG, CHARACTER SOMETIMES APPEARES ON THE SAME POSITION THAT A TREE IS

set({
  title: "The Game Continues",
  width: WIDTH,
  height: HEIGHT,
  # diagnostics: true
})

$map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
$background = Background.new
$character = Character.new(30, 20)

$fps_drawer = FpsDrawer.new
$mouse_background_drawer = MouseBackgroundDrawer.new
$day_and_night_cycle = DayAndNightCycle.new
$game_speed = GameSpeed.new

@tick = 0
def update_with_tick(&block)
  update do
    block.call(@tick)
    @tick = (@tick + 1) % 60
  end
end

update_with_tick do |tick|
  mouse_x = (get(:mouse_x) / PIXELS_PER_SQUARE)
  mouse_y = (get(:mouse_y) / PIXELS_PER_SQUARE)

  $mouse_background_drawer.rerender(mouse_x, mouse_y)

  if tick % 30 == 0
    fps = get(:fps)
    $fps_drawer.rerender(fps)
  end

  $character.update
  $day_and_night_cycle.update
end

# pre-calculate where passable areas are with flooding the map from characters position
# Use that information to help with maps passable information

# It should have 4 ticks per one changing of coordinates
# Then implement action responsible for cutting trees
# It should do one hit each N ticks, tree should fell after K hits
# And be changed to pile of logs
# When tree is hit that tile should be covered by red with high opacity for somewhere
# between 2 to 5 ticks, to indicate that it was being hit

# Then figure out logistics of building a house

# Maybe have queue of actions per person? Like: My main goal for now is to build a house
# But from time to time I have to stop it to sleep and eat
# But when I wake up, I want to get back to it

# Have a fireplace that will require adding wood to it
# The more the fireplace has ticks left, the brighter it shines
# and more tiles around is being light
# With the light think about day/night cycle: 60 ticks == 1 hour, implement shading based on sine of time
# Where darkest will be at midnight, lightest at noon ?

# With that introduce config file with all the informations that need to be setup
# like how long does it take to move, how fast do people get hungry and so on

# When creating buildings is ready, look into feeding people.
# When that is done, look into having a settlement that is sentient
# And gives jobs to make itself functional

# Introduce carrying by people
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

# BUG: CRASH ON ATTEMPT TO GO TO CLOSED AREA

on(mouse: 'any') do |x, y|
  in_game_x = x / PIXELS_PER_SQUARE
  in_game_y = y / PIXELS_PER_SQUARE

  if $map.passable?(in_game_x, in_game_y)
    $character.move_to(in_game_x, in_game_y)
  end
end

on_key do |key|
  if key == "escape"
    puts "pressed key: #{key}"
    close
  end

  if key == "1"
    $game_speed.set(1)
  end
  if key == "2"
    $game_speed.set(2)
  end
  if key == "3"
    $game_speed.set(4)
  end
end

$background.rerender
$character.rerender
$map.rerender

show
