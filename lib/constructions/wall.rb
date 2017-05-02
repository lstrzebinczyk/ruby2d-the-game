class Wall
  def self.size
    1
  end

  def self.structure_requirements
    [Log]
  end

  def self.building_time
    1.hour
  end

  def initialize(x, y)
    @x, @y = x, y
    render
  end

  def render
    @image = Image.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      "assets/constructions/wall/wall.png"
    )
    @image.color = "brown"
  end

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
  end

  # class Blueprint
  #   attr_reader :x, :y

  #   def initialize(x, y)
  #     @x, @y = x, y
  #     @updated = false
  #     render_image
  #   end

  #   def render_image
  #     wall_pathname = "wall"

  #     # NORTH
  #     north_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y - 1) }
  #     if north_construction
  #       wall_pathname += "-north"
  #     end

  #     # SOUTH
  #     south_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y + 1) }
  #     if south_construction
  #       wall_pathname += "-south"
  #     end

  #     # WEST
  #     west_construction = $constructions.find{|construction| construction_matches?(construction, @x - 1, @y) }
  #     if west_construction
  #       wall_pathname += "-west"
  #     end

  #     # EAST
  #     east_construction = $constructions.find{|construction| construction_matches?(construction, @x + 1, @y) }
  #     if east_construction
  #       wall_pathname += "-east"
  #     end

  #     @image = Image.new(
  #       x * PIXELS_PER_SQUARE,
  #       y * PIXELS_PER_SQUARE,
  #       "assets/constructions/wall/#{wall_pathname}.png"
  #     )
  #     @image.color = "gray"
  #     @image.color.opacity = 0.4
  #   end

  #   def update_image
  #     @image.remove
  #     render_image
  #   end

  #   private

  #   def construction_matches?(construction, x, y)
  #     construction.is_a?(Wall::Blueprint) and construction.x == x and construction.y == y
  #   end
  # end
end
