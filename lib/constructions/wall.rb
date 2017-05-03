class Wall
  class Blueprint < Structure::Base
    def self.size
      1
    end

    attr_reader :needs, :jobs
    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x, y
      @updated = false

      @needs = []
      @jobs  = []

      Wall.structure_requirements.each do |requirement|
        @needs << requirement
        @jobs << SupplyJob.new(requirement, to: self)
      end

      render_image
    end


    def remove
      @image.remove
    end

    def supply(item)
      if @needs.include?(item.class)
        @needs.delete(item.class)
        if @needs.empty?
          self.remove
          $structures.delete(self)
          $structures << Wall::Construction.new(@x, @y)
        end
      else
        require "pry"
        binding.pry
        raise ArgumentError, "Incorrect item brought"
      end
    end

    def render_image
      wall_pathname = "wall"

      # NORTH
      north_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y - 1) }
      if north_construction
        wall_pathname += "-north"
      end

      # SOUTH
      south_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y + 1) }
      if south_construction
        wall_pathname += "-south"
      end

      # WEST
      west_construction = $constructions.find{|construction| construction_matches?(construction, @x - 1, @y) }
      if west_construction
        wall_pathname += "-west"
      end

      # EAST
      east_construction = $constructions.find{|construction| construction_matches?(construction, @x + 1, @y) }
      if east_construction
        wall_pathname += "-east"
      end

      @image = Image.new(
        x * PIXELS_PER_SQUARE,
        y * PIXELS_PER_SQUARE,
        "assets/constructions/wall/#{wall_pathname}.png"
      )
      @image.color = "blue"
      @image.color.opacity = 0.4
    end

    def update_image
      @image.remove
      render_image
    end

    private

    def construction_matches?(construction, x, y)
      construction.is_a?(Wall::Blueprint) and construction.x == x and construction.y == y
    end
  end

  class Construction < Structure::Base
    def self.size
      1
    end

    attr_reader :needs, :jobs
    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x, y
      @updated = false

      @needs = []
      @jobs  = []

      @jobs  = [BuildJob.new(structure: self)]

      render_image
    end

    def building_time
      Wall.building_time
    end

    def remove
      @image.remove
    end

    def finished_building!
      self.remove
      $structures.delete(self)

      $map[@x, @y].content = Wall.new(@x, @y)
    end

    def render_image
      wall_pathname = "wall"

      # NORTH
      north_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y - 1) }
      if north_construction
        wall_pathname += "-north"
      end

      # SOUTH
      south_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y + 1) }
      if south_construction
        wall_pathname += "-south"
      end

      # WEST
      west_construction = $constructions.find{|construction| construction_matches?(construction, @x - 1, @y) }
      if west_construction
        wall_pathname += "-west"
      end

      # EAST
      east_construction = $constructions.find{|construction| construction_matches?(construction, @x + 1, @y) }
      if east_construction
        wall_pathname += "-east"
      end

      @image = Image.new(
        x * PIXELS_PER_SQUARE,
        y * PIXELS_PER_SQUARE,
        "assets/constructions/wall/#{wall_pathname}.png"
      )
      @image.color = "gray"
      @image.color.opacity = 0.4
    end

    def update_image
      @image.remove
      render_image
    end

    private

    def construction_matches?(construction, x, y)
      construction.is_a?(Wall::Blueprint) and construction.x == x and construction.y == y
    end
  end

  def self.structure_requirements
    [Log]
  end

  def self.size
    1
  end

  def self.building_time
    1.hour
  end

  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
    render
  end

  def render
    render_image
  end

  def impassable?
    true
  end

  def render_image
    wall_pathname = "wall"

    # NORTH
    north_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y - 1) }
    if north_construction
      wall_pathname += "-north"
    end

    # SOUTH
    south_construction = $constructions.find{|construction| construction_matches?(construction, @x, @y + 1) }
    if south_construction
      wall_pathname += "-south"
    end

    # WEST
    west_construction = $constructions.find{|construction| construction_matches?(construction, @x - 1, @y) }
    if west_construction
      wall_pathname += "-west"
    end

    # EAST
    east_construction = $constructions.find{|construction| construction_matches?(construction, @x + 1, @y) }
    if east_construction
      wall_pathname += "-east"
    end

    @image = Image.new(
      x * PIXELS_PER_SQUARE,
      y * PIXELS_PER_SQUARE,
      "assets/constructions/wall/#{wall_pathname}.png"
    )
    @image.color = "brown"
    @image.color.opacity = 0.4
  end

  def x=(x)
    @x = x
    @image.x = x * PIXELS_PER_SQUARE
  end

  def y=(y)
    @y = y
    @image.y = y * PIXELS_PER_SQUARE
  end

end
