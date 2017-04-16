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
    $map.find_closest_to(@to) do |tile|
      tile.is_a? @item_class or (tile.is_a?(Container) and tile.contains?(@item_class))
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
      PickAction.new(tile_with_item_cached, character, on_abandon: on_abandon)
    end.then do
      MoveAction.new(character: character, near: @to)
    end.then do
      SupplyAction.new(@to, character)
    end
  end

  def remove
  end
end
