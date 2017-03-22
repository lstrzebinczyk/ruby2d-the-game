require 'ruby2d'

require_relative "./core_ext/time"

require_relative "./actions/move_action"
require_relative "./actions/cut_tree_action"

require_relative "./jobs/cut_tree_job"

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
require_relative "./utils/logs_pile"
require_relative "./utils/fireplace"
require_relative "./utils/job_list"

# http://www.ruby2d.com/learn/reference/
PIXELS_PER_SQUARE = 16
SQUARES_WIDTH     = 60
SQUARES_HEIGHT    = 40
WIDTH  = PIXELS_PER_SQUARE * SQUARES_WIDTH
HEIGHT = PIXELS_PER_SQUARE * SQUARES_HEIGHT

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
  height: HEIGHT,
  # diagnostics: true
})

$map = Map.new(width: SQUARES_WIDTH, height: SQUARES_HEIGHT)
$background = Background.new

$map.clear(30, 20) # Make sure there is nothing but the character at this position
$character = Character.new(30, 20)

$fps_drawer = FpsDrawer.new
$mouse_background_drawer = MouseBackgroundDrawer.new

class Rectangle
  def contains?(x, y)
    (@x..(@x + @width)).include?(x) && (@y..(@y + @height)).include?(y)
  end
end

class Menu
  class Button
    FONT_SIZE = 36
    def initialize(text, opts = {})
      @text   = text
      @active = opts[:active] || false
      @hover  = false
    end

    def rerender
      remove 
      add
    end

    def remove
      @text_element.remove 
      @background.remove
    end

    def add
      @background.add 
      @text_element.add
    end

    def contains?(x, y)
      @background.contains?(x, y)
    end

    def width
      FONT_SIZE * @text.length * 0.5
    end

    def color
      if @active
        [1, 0, 0, opacity]
      else
        [0, 0, 1, opacity]
      end
    end

    def opacity
      if @hover
        0.6
      else
        1
      end
    end

    def hover
      @hover = true
      @background.color = color
    end

    def unhover
      @hover = false
      @background.color = color
    end

    def render(x, y)
      menu_element_tiles_height = 3
      @background = Rectangle.new(
        x, 
        y, 
        width, # TWEAK IT 
        menu_element_tiles_height * PIXELS_PER_SQUARE, 
        color
      )

      @text_element = Text.new(
        x + 4, 
        y + 4, 
        @text, FONT_SIZE, "fonts/arial.ttf"
      )
    end
  end

  def initialize
    @game_mode = :cut_trees # later this should be something like :give_orders, something more generic
    @menu_y_start = HEIGHT - height

    render
  end

  def height
    5 * PIXELS_PER_SQUARE
  end

  # those x and y are not in-game x, y
  # they are windows x, y
  # basically for now if y > menus height from bottom, return true
  def contains?(x, y)
    y > @menu_y_start
  end

  def rerender
    [@menu_background, @cut_trees_button, @do_nothing_button].each do |elem|
      elem.remove
      elem.add
    end
  end

  def render
    render_menu_background
    render_cut_trees_element
    render_nothing_element
  end

  def unhover
    @cut_trees_button.unhover
    @do_nothing_button.unhover
  end

  def hover(window_x, window_y)
    if @cut_trees_button.contains?(window_x, window_y)
      @cut_trees_button.hover
    end

    if @do_nothing_button.contains?(window_x, window_y)
      @do_nothing_button.hover
    end
  end

  private

  def render_cut_trees_element
    @cut_trees_button = Button.new("Cut trees", active: true)
    @cut_trees_button.render(PIXELS_PER_SQUARE, @menu_y_start + PIXELS_PER_SQUARE)
  end

  def render_nothing_element
    @do_nothing_button = Button.new("Do nothing")
    left = 2 * PIXELS_PER_SQUARE + @cut_trees_button.width

    @do_nothing_button.render(left, @menu_y_start + PIXELS_PER_SQUARE)
  end

  def render_menu_background
    @menu_background = Rectangle.new(0, @menu_y_start, WIDTH, height, "black")
  end
end

$menu = Menu.new


$day_and_night_cycle = DayAndNightCycle.new(HEIGHT - $menu.height)
$game_speed = GameSpeed.new
$fireplace = Fireplace.new
$job_list = JobList.new

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

  # Only show mouse button if it's on map
  # don't show anything if it's on menu
  $mouse_background_drawer.remove
  $menu.unhover
  if $menu.contains?(get(:mouse_x), get(:mouse_y))
    $menu.hover(get(:mouse_x), get(:mouse_y))
  else
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

  $job_list.cleanup if tick % 300 == 0
end

# Have menu options to choose between
  # - i want to set trees to be removed
  # - i want to build
  #   - storage
  #   - dormitory ? next step, we need sleeping for that




# introduce ability to unqueue jobs

# When those are done we can talk about building storages

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

# REMOVABLE MODULE TO UNIFY MAP BEHAVIOR? ADDING AND REMOVING TO RENDER BEHAVIOR?
# RENDERABLE MODULE?

# FIRST OF ALL INTRODUCE BUILDING A STORAGE

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

# Have color allow to set opacity with setter?
# Implement Color#opacity=
# Alias of  Color#a=

# introduce sleeping

# FONT IN WEB VERSION DOES NOT RENDER IN PROPER SIZE

# GET WIDTH FROM TEXT?
# To build something around it?

# Implement #include? method for drawed shapes
# to allow checking if a mouse is over them

on(mouse: 'any') do |x, y|
  # Only take consider user action if it clicks on map
  # not if it clicks on menu
  unless $menu.contains?(x, y)
    in_game_x = x / PIXELS_PER_SQUARE
    in_game_y = y / PIXELS_PER_SQUARE

    map_object = $map[in_game_x, in_game_y]
    if map_object.is_a? Tree
      new_job = CutTreeJob.new(map_object)

      # Do not queue this same job multiple times, for example do not add
      # the same tree to be cut 2 times
      if $job_list.has?(new_job)
        new_job.remove
      else
        $job_list.add(new_job)
      end
    end
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
