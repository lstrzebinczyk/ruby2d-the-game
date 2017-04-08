class SupplyJob
  def initialize(item_type, opts)
    @item_type = item_type
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
      tile && tile.contains?(@item_type)
    end
  end

  def target
    [@item_type, @to]
  end

  def action_for(character)
    tile_with_item_cached = tile_with_item

    MoveAction.new(character: character, near: tile_with_item_cached).then do
      PickAction.new(tile_with_item_cached, character)
    end.then do
      MoveAction.new(character: character, near: @to)
    end.then do
      SupplyAction.new(@to, character)
    end
  end

  def remove
  end
end
