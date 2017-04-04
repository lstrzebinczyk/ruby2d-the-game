require "spec_helper"

describe "Map" do
  it "doesn't crash on generating reasonable content" do
    m = Map.new(width: 20, height: 20)
    m.fill_grid_with_objects
  end

  # it "finds closest map position" do
  #   map = Map.new(width: 3, height: 3)
  #   (0..2).each do |x|
  #     (0..2).each do |y|
  #       map[x, y] = Tree.new(x, y)
  #     end
  #   end

  #   middle_tree = map[1, 1]
  #   position = map.find_free_spot_near(middle_tree)

  #   expect(position.x).to be
  #   expect(position.y).to be
  # end
end
