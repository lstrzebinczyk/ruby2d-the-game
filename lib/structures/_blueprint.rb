class Blueprint < Structure::Base
  class Inspection
    def initialize(blueprint, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x, y, "Blueprint (#{blueprint.structure_class})", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 20, "Needs #{blueprint.needs}", 16, "fonts/arial.ttf")
      @texts << Text.new(x, y + 40, "Jobs: #{blueprint.jobs.map(&:class)}", 16, "fonts/arial.ttf")

    end

    def remove
      @texts.each(&:remove)
    end
  end

  attr_reader :needs, :jobs, :structure_class, :x, :y

  def initialize(structure_class, x, y)
    @structure_class = structure_class
    @size            = structure_class.size
    @x, @y = x, y

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "blue")
    @mask.color.opacity = 0.4

    @needs = []
    @jobs  = []

    structure_class.structure_requirements.each do |requirement|
      @needs << requirement
      @jobs << SupplyJob.new(requirement, to: self)
    end
  end

  def size
    @structure_class.size
  end

  def remove
    @mask.remove
  end

  def supply(item)
    if @needs.include?(item.class)
      @needs.delete(item.class)
      if @needs.empty?
        self.remove
        $structures.delete(self)
        $structures << Construction.new(@structure_class, @x, @y)
      end
    else
      require "pry"
      binding.pry
      raise ArgumentError, "Incorrect item brought"
    end
  end
end
