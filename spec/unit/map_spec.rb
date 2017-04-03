require "spec_helper"

describe "Map" do
  it "doesn't crash on generating reasonable content" do
    m = Map.new(width: 20, height: 20)
    m.fill_grid_with_objects
  end
end
