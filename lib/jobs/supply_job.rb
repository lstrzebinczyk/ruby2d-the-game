class SupplyJob
  def initialize(item_class, opts)
    @item_class = item_class
    @to = opts[:to]
  end

  def type
    :haul
  end

  def available?
    !!tile_with_item
  end

  def tile_with_item
    $map.spots_near(@to).find do |spot|
      spot.content.is_a? @item_class or (spot.content.is_a?(Container) and spot.content.contains?(@item_class))
    end
  end

  def target
    [@item_class, @to]
  end

  def action_for(character)
    tile_with_item_cached = tile_with_item

    MoveAction.new(character: character, near: tile_with_item_cached).then do
      on_abandon = -> {
        @to.jobs << SupplyJob.new(@item_class, to: @to)
      }
      if tile_with_item_cached.is_a? Container
        GetAction.new(@item_class,
          from: tile_with_item_cached,
          character: character,
          on_abandon: on_abandon
        )
      else
        PickAction.new(tile_with_item_cached, character, on_abandon: on_abandon)
      end
    end.then do
      MoveAction.new(character: character, near: @to)
    end.then do
      SupplyAction.new(@to, character)
    end
  end

  def remove
  end
end
