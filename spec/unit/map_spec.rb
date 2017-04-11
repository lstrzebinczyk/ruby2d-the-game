require "spec_helper"

class FakeFloodMap
  def available?(x, y)
    true
  end
end

describe "Map" do
  it "doesn't crash on generating reasonable content" do
    m = Map.new(width: 20, height: 20)
    m.fill_grid_with_objects
  end

  it "finds closest map position" do
    map = Map.new(width: 5, height: 5)
    (1..3).each do |x|
      (1..3).each do |y|
        map[x, y] = Tree.new(x, y)
      end
    end

    $flood_map = FakeFloodMap.new

    middle_tree = map[2, 2]
    position = map.find_free_spot_near(middle_tree)

    expect(position.x).to eq(0)
    expect(position.y).to eq(0)
  end
end
