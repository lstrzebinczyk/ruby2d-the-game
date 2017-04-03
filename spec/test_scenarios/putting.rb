class PuttingToOtherZoneTestScenario
  Position = Struct.new(:x, :y)

  def initialize
    template = "L..W..SS" # F => Filled Storage
    @world = WorldBuilder.new(template).build
    carry_job = CarryLogJob.new(from: Position.new(0, 0))
    $job_list.add(carry_job)
  end

  # Character will try to move the log to (0, 6), but it gets filled before he gets there
  # So he looks for another storage spot and moves the log there
  def run!
    while $map[0, 0].is_a? LogsPile
      @world.update
    end

    $map[6, 0] = LogsPile.new(6, 0, 6)

    while !$map[7, 0].is_a? LogsPile
      @world.update
    end
  end
end

class PuttingOnGroundTestScenario
  Position = Struct.new(:x, :y)

  def initialize
    template = "L..W..S" # F => Filled Storage
    @world = WorldBuilder.new(template).build
    carry_job = CarryLogJob.new(from: Position.new(0, 0))
    $job_list.add(carry_job)
  end

  # Character will try to move the log to (0, 6), but it gets filled before he gets there
  # So he looks for another storage spot and moves the log there
  # And can't find one, so he throws the log on ground
  def run!
    while $map[0, 0].is_a? LogsPile
      @world.update
    end

    $map[6, 0] = LogsPile.new(6, 0, 6)

    while $map.count{|el| el.is_a? LogsPile } != 2 do
      @world.update
    end
  end
end

