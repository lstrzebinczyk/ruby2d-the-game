class Construction < Structure::Base
  class Inspection
    def initialize(construction, opts = {})
      x = opts[:x]
      y = opts[:y]
      @text = Text.new(x, y, "Construction (#{construction.structure_class})", 16, "fonts/arial.ttf")
    end

    def remove
      @text.remove
    end
  end

  attr_reader :structure_class, :x, :y

  def initialize(structure_class, x, y)
    @structure_class = structure_class
    @size            = structure_class.size
    @x, @y = x, y

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "gray")
    @mask.color.opacity = 0.8

    @jobs  = [BuildJob.new(structure: self)]
  end

  def size
    @structure_class.size
  end

  def building_time
    @structure_class.building_time
  end

  def remove
    @mask.remove
  end

  def finished_building!
    self.remove
    $structures.delete(self)

    if @structure_class.ancestors.include?(Structure::Base)
      $structures << @structure_class.new(@x, @y)
    else
      $map[@x, @y].content = @structure_class.new(@x, @y)
    end
  end
end
