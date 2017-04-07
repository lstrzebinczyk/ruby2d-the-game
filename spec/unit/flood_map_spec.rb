require "spec_helper"

describe "FloodMap" do
  it "will say there is no access if spot is surrounded by trees" do
template = """
TTT...
T.T..W
TTT...
"""
    @world = WorldBuilder.new(template).build
    expect($flood_map.available?(1, 1)).to be false
  end

  it "is updated when things are cleared from map" do
template = """
TTT...
T.T..W
TTT...
"""
    @world = WorldBuilder.new(template).build
    $map.clear(2, 1)
    expect($flood_map.available?(1, 1)).to be true
  end
end
