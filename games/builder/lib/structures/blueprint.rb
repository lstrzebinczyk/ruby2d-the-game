class Blueprint < Structure::Base
  class Inspection
    def initialize(blueprint, opts = {})
      x = opts[:x]
      y = opts[:y]
      @texts = []
      @texts << Text.new(x: x, y: y,      text: "Blueprint (#{blueprint.structure_class})", size: 16, font: "fonts/arial.ttf")
      @texts << Text.new(x: x, y: y + 20, text: "Needs #{blueprint.needs}",                 size: 16, font: "fonts/arial.ttf")
      @texts << Text.new(x: x, y: y + 40, text: "Jobs: #{blueprint.jobs.map(&:class)}",     size: 16, font: "fonts/arial.ttf")
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

    @mask = MapRenderer.square(x, y, @size, "blue", ZIndex::STRUCTURE)
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
