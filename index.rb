require 'ruby2d'
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

set({
  title: "The Game Continues",
  width: WIDTH,
  height: HEIGHT,
  diagnostics: true
})

def draw_background
  Image.new(0, 0, "assets/nature/background.png")
end

def draw_character
  Image.new(WIDTH / 2, HEIGHT / 2, "assets/characters/woodcutter.png")
end

@fps_text = Text.new(15, 15, "fps: 0", 40, "fonts/arial.ttf")
def draw_fps
  fps = get(:fps).to_i
  @fps_text.remove
  @fps_text.text = "fps: #{fps}"
  @fps_text.add
end

@old_mouse_background_x = 0
@old_mouse_background_y = 0
@mouse_background_image = Square.new(100, 100, PIXELS_PER_SQUARE, [1, 1, 1, 0.2])

def draw_mouse_background
  x = (get(:mouse_x) / PIXELS_PER_SQUARE) * PIXELS_PER_SQUARE
  y = (get(:mouse_y) / PIXELS_PER_SQUARE) * PIXELS_PER_SQUARE
  @mouse_background_image.remove
  @mouse_background_image.x = x
  @mouse_background_image.y = y
  @mouse_background_image.add
end

class Map
end

@map = Map.new

Point = Struct.new(:x, :y)

@point_to_go = Point.new(0, 0)

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


on_key do |key|
  if key == "escape"
    close
  end
end


draw_background
draw_character

show
