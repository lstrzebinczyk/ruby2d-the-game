class PuttingToOtherZoneTestScenario
  Position = Struct.new(:x, :y)

  def initialize
    template = "L..W..SS"
    @world = WorldBuilder.new(template).build
    carry_job = StoreJob.new(Position.new(0, 0))
    $job_list.add(carry_job)
  end

  # Character will try to move the log to (0, 6), but it gets filled before he gets there
  # So he looks for another storage spot and moves the log there
  def run!
    time_start = Time.now

    while $map[0, 0].is_a? Log
      @world.update

      if Time.now - time_start > 5
        raise Error, "Timeout in test"
      end
    end

    $map[6, 0] = Log.new(6, 0)

    while !$map[7, 0].is_a? Log
      @world.update

      if Time.now - time_start > 5
        raise Error, "Timeout in test"
      end
    end
  end
end

class PuttingOnGroundTestScenario
  Position = Struct.new(:x, :y)

  def initialize
    template = """
.......
L..W..S
.......
""" # F => Filled Storage
    @world = WorldBuilder.new(template).build
    carry_job = StoreJob.new(Position.new(0, 0))
    $job_list.add(carry_job)
  end

  # Character will try to move the log to (0, 6), but it gets filled before he gets there
  # So he looks for another storage spot and moves the log there
  # And can't find one, so he throws the log on ground
  def run!
    time_start = Time.now

    while $map[0, 0].is_a? Log
      @world.update

      if Time.now - time_start > 5
        raise Error, "Timeout in test"
      end
    end

    $map[6, 0] = Log.new(6, 0)

    while $map.count{|el| el.is_a? Log } != 2 do
      @world.update

      if Time.now - time_start > 5
        raise Error, "Timeout in test"
      end
    end
  end
end

