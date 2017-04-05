class BerriesCuttingTestScenario
  def initialize
    template = """
........
BBB.W.SS
........
"""
    @world = WorldBuilder.new(template).build

    remove_game_mode = RemoveGameMode.new

    $map.each do |elem|
      if elem.is_a? BerryBush
        remove_game_mode.perform(elem.x, elem.y)
      end
    end
  end

  def run!
    iterations = 0
    time_start = Time.now

    should_continue = true

    while should_continue
      iterations += 1
      @world.update

      if iterations % 1000 == 0
        should_continue = !done?
      end

      if Time.now - time_start > 5
        raise Error, "Timeout in test"
      end
    end
  end

  private

  def no_more_berry_bushes?
    $map.count{|thing| thing.is_a? BerryBush } == 0
  end

  def done?
    no_more_berry_bushes?
  end
end
