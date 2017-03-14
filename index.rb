require 'ruby2d'
require 'pry'


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

set({
  title: "The Game Continues",
  width: WIDTH,
  height: HEIGHT,
  diagnostics: true
})

def draw_background
  SQUARES_WIDTH.times do |x|
    SQUARES_HEIGHT.times do |y|
      Image.new(PIXELS_PER_SQUARE * x, PIXELS_PER_SQUARE * y, "assets/nature/ground.png")
    end
  end
end

def draw_character
  Image.new(WIDTH / 2, HEIGHT / 2, "assets/characters/woodcutter.png")
end

def draw_fps
  fps = get(:fps).round(1).to_s
  if fps.length < 4
    fps += "0"
  end

  Rectangle.new(0, 0, 210, 80, "black")
  Text.new(15, 15, "fps: #{fps}", 40, "fonts/arial.ttf")
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

@tick = 0
def update_with_tick(&block)
  update do
    block.call(@tick)
    @tick = (@tick + 1) % 60
  end
end


draw_background
draw_character

update_with_tick do |tick|
  draw_fps if tick & 30 == 0
  draw_mouse_background
end

show
