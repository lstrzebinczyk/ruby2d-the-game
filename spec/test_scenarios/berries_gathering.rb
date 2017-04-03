class BerriesGatheringTestScenario
  def initialize
template = """
.....BB..SS
.....BG..SS
.........SS
"""
    @world = WorldBuilder.new(template).build
    BuildKitchenGameMode.new.perform(0, 0)

    kitchen = $structures.find{|s| s.is_a? Kitchen }
    20.times{ kitchen.ensure_more_berries }
  end

  def run!
    iterations = 0
    should_continue = true

    while should_continue
      iterations += 1
      @world.update

      if iterations % 1000 == 0
        should_continue = !done?
      end
    end
  end

  private

  def done?
    enough_berries_in_store?
  end

  def enough_berries_in_store?
    stored_berries_kgs >= 20 * 0.3 * 1000
  end

  def stored_berries_kgs
    $map.find_all{|thing| thing.is_a? BerriesPile }.keep_if do |berries_pile|
      x = berries_pile.x
      y = berries_pile.y
      $zones.find{|zone| zone.x == x and zone.y == y}
    end.map{|berries_pile| berries_pile.grams }.inject(0, :+)
  end
end
