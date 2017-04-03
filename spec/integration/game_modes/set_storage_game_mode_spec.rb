require "spec_helper"

describe "SetStorageGameMode" do
  it "sets storage in given spot" do
    template = "."
    @world = WorldBuilder.new(template).build
    SetStorageGameMode.new.click(0, 0)

    expect($zones.count).to eq(1)
    expect($zones.first.x).to eq(0)
    expect($zones.first.y).to eq(0)
  end

  it "doesn't set the storage second time if there already is set storage" do
    template = "."
    @world = WorldBuilder.new(template).build
    SetStorageGameMode.new.click(0, 0)
    SetStorageGameMode.new.click(0, 0)

    expect($zones.count).to eq(1)
    expect($zones.first.x).to eq(0)
    expect($zones.first.y).to eq(0)
  end

  it "makes sure mask is rendered below previously present elements" do
    template = "T"
    @world = WorldBuilder.new(template).build
    SetStorageGameMode.new.click(0, 0)

    tree_image = GameWorld.things_at(0, 0).find{|el| el.is_a? Tree }.image
    zone_image = GameWorld.things_at(0, 0).find{|el| el.is_a? StorageZone }.image

    rendered_objects = Application.get(:window).objects

    expect(rendered_objects.index(tree_image)).to be > rendered_objects.index(zone_image)
  end

  it "hovers and unhovers safely" do
    template = "."
    @world = WorldBuilder.new(template).build
    SetStorageGameMode.new.hover(0, 0)
    SetStorageGameMode.new.unhover
  end
end
