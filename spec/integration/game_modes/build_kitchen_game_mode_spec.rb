require "spec_helper"

describe "BuildKitchenGameMode" do
  it "hovers and unhovers over clear terrain" do
    template = "."
    @world = WorldBuilder.new(template).build
    BuildKitchenGameMode.new.hover(0, 0)
    BuildKitchenGameMode.new.unhover
  end

  it "hovers and unhovers over unclear terrain" do
    template = "T"
    @world = WorldBuilder.new(template).build
    BuildKitchenGameMode.new.hover(0, 0)
    BuildKitchenGameMode.new.unhover
  end

  data = {
    "T" => "Tree",
    "W" => "Character",
    "S" => "Storage Zone"
  }

  data.each do |template_key, name|
    it "will not build kitchen over #{name}" do
      template = template_key
      @world = WorldBuilder.new(template).build
      BuildKitchenGameMode.new.click(0, 0)
      expect($structures.count).to eq(0)
    end
  end

  it "will build kitchen over free space" do
    template = "."
    @world = WorldBuilder.new(template).build
    BuildKitchenGameMode.new.click(0, 0)
    expect($structures.count).to eq(1)
    expect($structures.first).to be_a Kitchen
    expect($structures.first.x).to eq 0
    expect($structures.first.y).to eq 0
  end

  it "changes to inspect game mode on success" do
    template = "."
    @world = WorldBuilder.new(template).build
    $menu = Menu.new

    BuildKitchenGameMode.new.click(0, 0)

    expect($menu.game_mode).to be_a InspectGameMode
  end
end
