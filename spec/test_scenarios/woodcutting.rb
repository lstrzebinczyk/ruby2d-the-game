class WoodcuttingTestScenario
  def initialize(opts)

# This is so big because I want it to trigger sleeping and eating
template = """
..........
.T.T.BW.SS.
.T.T....SS.
.T.T....SS.
...........
"""

    opts[:berry_bush_grams] = 1000000
    @timeout = opts[:timeout] || 5
    @world = WorldBuilder.new(template, opts).build

    cut_game_mode = CutGameMode.new
    $map.each do |elem|
      if elem.is_a? Tree
        cut_game_mode.perform(elem.x, elem.y)
      end
    end
  end

  def run!
    time_start = Time.now

    iterations = 0

    should_continue = true

    while should_continue
      iterations += 1
      @world.update

      if iterations % 1000 == 0
        should_continue = !done?
      end

      if Time.now - time_start > @timeout
        raise Error, "Timeout in test"
      end
    end
  end

  private

  def no_more_trees?
    $map.count{|thing| thing.is_a? Tree } == 0
  end

  def unstored_logs
    $map.find_all{|thing| thing.is_a? LogsPile }.count do |logs_pile|
      x = logs_pile.x
      y = logs_pile.y
      !$zones.find{|zone| zone.x == x and zone.y == y}
    end
  end

  def all_logs_in_stores?
    unstored_logs == 0
  end

  def done?
    no_more_trees? && all_logs_in_stores?
  end
end
