class Workshop < Structure::Base
  attr_reader :x, :y, :size

  def initialize(x, y)
    @x, @y = x, y
    @size  = 3

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, 3 * PIXELS_PER_SQUARE, "blue")
    @mask.color.opacity = 0.4

    @stage = :blueprint
    @needs = [:log]

    supply_job = SupplyJob.new(:log, to: self)
    $job_list.add(supply_job)
  end

  def passable?
    true
  end

  def supply(item)
    if @needs.include?(item.type)
      @needs.delete(item.type)
      if @needs.empty?
        @stage = :building
        @mask.color = "gray"
        @mask.color.opacity = 0.8

        build_job = BuildJob.new(structure: self)
        $job_list.add(build_job)
      end
    else
      require "pry"
      binding.pry
      raise ArgumentError, "Incorrect item brought"
    end
  end

  def finished_building!
    @mask.color = "green"
    @mask.color.opacity = 0.6
    @stage = :finished
  end

  def building_time
    20.minutes
  end

  # If it's blueprint stage, we need to bring all of the needed materials to structure
  # Then it's building time
  # Then structure can be used

  def has_job?(type)
    false
    # if @stage == :blueprint
    #   if type == :haul

    #   end
    # end
  end

  def update(time)
  end
end
