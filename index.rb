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

set({
  title: "The Game Continues",
  width: WIDTH,
  height: HEIGHT
})

SQUARES_WIDTH.times do |x|
  SQUARES_HEIGHT.times do |y|
    Image.new(PIXELS_PER_SQUARE * x, PIXELS_PER_SQUARE * y, "assets/ground.png")
  end
end

def draw_fps
  fps = get(:fps).round(1).to_s
  if fps.length < 4
    fps += "0"
  end

  Rectangle.new(0, 0, 210, 80, "black")
  Text.new(15, 15, "fps: #{fps}", 40, "fonts/arial.ttf")
end

@tick = 0
def update_with_tick(&block)
  update do
    block.call(@tick)
    @tick = (@tick + 1) % 60
  end
end

update_with_tick do |tick|
  draw_fps if tick & 30 == 0
end


# Square.new(0, 0, 16, "red")
# Square.new(16, 16, 16, "blue")

# Square.new(50, 50, 125)

# start_time = Time.now
# time       = Time.now
# third_color = 1
# # color = Color.new([0, 0, 1, 1])

# Triangle.new(
#   320,  50,
#   540, 430,
#   100, 430,
#   ['red', 'green', [0, 0, third_color, 1]]
# )

# update do
#   time_passed = Time.now - start_time
#   third_color = Math.sin(3 * time_passed).abs

#   # Triangle.new(
#   #   320,  50,
#   #   540, 430,
#   #   100, 430,
#   #   ['red', 'green', [0, 0, third_color, 1]]
#   # )

#   # # puts "FPS: #{(Time.now - time).round(2)}"
#   # time        = Time.now

#   # sleep 0.01

# end

show
