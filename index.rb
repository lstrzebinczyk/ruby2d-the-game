require 'ruby2d'
require_relative "./lib/a_star"
# require 'pry'


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

# IMPLEMENT A* (COPY FROM?)
# https://github.com/Pommespanzer/astar-ruby/blob/master/astar.rb

# ONLY RENDERING METHODS SHOULD BE CONCERNED WITH PIXELS PER SQUARE
# REST SHOULD ONLY HANDLE ABOUT IN-GAME POSITION

# SET GLOBAL VARIABLES WITH $!


set({
  title: "The Game Continues",
  width: WIDTH,
  height: HEIGHT,
  diagnostics: true
})

def draw_background
  Image.new(0, 0, "assets/nature/background.png")
end

class Position
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

@character_position = Position.new(30, 20)

class Character
  def initialize(x, y)
    @image = Image.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, "assets/characters/woodcutter.png")
  end

  def rerender
    @image.remove
    @image.add
  end
end

$character = Character.new(@character_position.x, @character_position.y)

def draw_character
  $character.rerender
end

@fps_text = Text.new(15, 15, "fps: 0", 40, "fonts/arial.ttf")
def draw_fps
  fps = get(:fps).to_i
  @fps_text.remove
  @fps_text.text = "fps: #{fps}"
  @fps_text.add
end

@to_go_position = Position.new(0, 0)
@old_mouse_background_x = 0
@old_mouse_background_y = 0
@mouse_background_image = Square.new(100, 100, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])

def draw_mouse_background
  x = (get(:mouse_x) / PIXELS_PER_SQUARE)
  y = (get(:mouse_y) / PIXELS_PER_SQUARE)

  @to_go_position.x = x
  @to_go_position.y = y

  @mouse_background_image.remove
  @mouse_background_image.x = x * PIXELS_PER_SQUARE
  @mouse_background_image.y = y * PIXELS_PER_SQUARE
  @mouse_background_image.add
end

class Path
  def initialize
    @shapes_to_render = []
  end

  def update(astar_result)
    @astar_result = astar_result
    render
  end

  private

  def render
    # require 'pry'
    # binding.pry

    @shapes_to_render.each(&:remove)
    @shapes_to_render = []

    @astar_result.each do |node|
      x = node.x * PIXELS_PER_SQUARE + PIXELS_PER_SQUARE / 4
      y = node.y * PIXELS_PER_SQUARE + PIXELS_PER_SQUARE / 4
      shape = Square.new(x, y, PIXELS_PER_SQUARE / 2, 'red')
      @shapes_to_render << shape
    end

    draw_character
  end
end

# class Map
#   def find_path(point_a, point_b)
#     Path.new
#   end
# end

# @map = Map.new
@path = Path.new

def calculate_path_to(x, y)
  # puts "Looking path from (#{@character_position.x}, #{@character_position.y}) to  (#{x}, #{y})"
  start       = { 'x' => @character_position.x, 'y' => @character_position.y }
  destination = { 'x' => x, 'y' => y }
  astar       = Astar.new(start, destination)
  result      = astar.search # returns Array
  @path.update(result)
end

# start       = { 'x' => 10, 'y' => 20 }
# destination = { 'x' => 23, 'y' => 15 }

# if (result.size > 0)
#   result.each{|node| # Astar_Node
#     # your code ...
#   }
# end


class ActionPoint
  def initialize
    @x = 0
    @y = 0
    @rendered = Square.new(0, 0, PIXELS_PER_SQUARE, [56.0 / 255, 25.0 / 255, 4.0 / 255, 0.6])
  end

  def update_position(x, y)
    @rendered.remove
    @x = x
    @y = y
    @rendered.x = x
    @rendered.y = y
    @rendered.add
  end
end

@action_point = ActionPoint.new

@tick = 0
def update_with_tick(&block)
  update do
    block.call(@tick)
    @tick = (@tick + 1) % 60
  end
end

update_with_tick do |tick|
  draw_fps if tick & 30 == 0
  draw_mouse_background
end

def mouse_clicked_on(x, y)
  x_position = PIXELS_PER_SQUARE * (x / PIXELS_PER_SQUARE)
  y_position = PIXELS_PER_SQUARE * (y / PIXELS_PER_SQUARE)

  @action_point.update_position(x_position, y_position)
  calculate_path_to(x / PIXELS_PER_SQUARE, y / PIXELS_PER_SQUARE)
end

on(mouse: 'any') do |x, y|
  mouse_clicked_on(x, y)
end

on_key do |key|
  if key == "escape"
    close
  end

  puts "pressed key: #{key}"
end



draw_background
draw_character


# start       = { 'x' => 10, 'y' => 20 }
# destination = { 'x' => 23, 'y' => 15 }
# astar       = Astar.new(start, destination)
# result      = astar.search # returns Array

# if (result.size > 0)
#   result.each{|node| # Astar_Node
#     # your code ...
#   }
# end

# FUCKING NICE!

# [1] pry(main)> result
# => [#<Astar_Node:0x00000001a47f80 @f=-1, @g=-1, @h=-1, @i=-1, @x=10, @y=20>,
#  #<Astar_Node:0x00000001a473f0 @f=22, @g=9, @h=13, @i=0, @x=11, @y=20>,
#  #<Astar_Node:0x00000001a450f0 @f=31, @g=19, @h=12, @i=2, @x=12, @y=20>,
#  #<Astar_Node:0x00000001a3f010 @f=40, @g=29, @h=11, @i=6, @x=13, @y=20>,
#  #<Astar_Node:0x000000019b8f10 @f=49, @g=39, @h=10, @i=14, @x=14, @y=20>,
#  #<Astar_Node:0x00000001a7d6f8 @f=58, @g=49, @h=9, @i=26, @x=15, @y=20>,
#  #<Astar_Node:0x00000001afc908 @f=67, @g=59, @h=8, @i=42, @x=16, @y=20>,
#  #<Astar_Node:0x00000001aa41e0 @f=76, @g=69, @h=7, @i=62, @x=17, @y=20>,
#  #<Astar_Node:0x00000001b31978 @f=86, @g=79, @h=7, @i=81, @x=17, @y=19>,
#  #<Astar_Node:0x00000001f575e8 @f=95, @g=89, @h=6, @i=105, @x=17, @y=18>,
#  #<Astar_Node:0x00000001d9e4b8 @f=104, @g=99, @h=5, @i=132, @x=18, @y=18>,
#  #<Astar_Node:0x00000001da1690 @f=114, @g=109, @h=5, @i=163, @x=18, @y=17>,
#  #<Astar_Node:0x00000001b3ed30 @f=123, @g=119, @h=4, @i=201, @x=19, @y=17>,
#  #<Astar_Node:0x00000001b30ff0 @f=132, @g=129, @h=3, @i=240, @x=20, @y=17>,
#  #<Astar_Node:0x00000001db1450 @f=141, @g=139, @h=2, @i=282, @x=21, @y=17>,
#  #<Astar_Node:0x00000001dbad20 @f=151, @g=149, @h=2, @i=325, @x=21, @y=16>,
#  #<Astar_Node:0x00000001dc2ed0 @f=160, @g=159, @h=1, @i=374, @x=22, @y=16>,
#  #<Astar_Node:0x00000001af6238 @f=170, @g=169, @h=1, @i=419, @x=22, @y=15>,
#  #<Astar_Node:0x00000001a47f58 @f=-1, @g=-1, @h=-1, @i=-1, @x=23, @y=15>]



# require 'pry'

# binding.pry

show
