require "spec_helper"

describe "InspectGameMode" do
  it "opens the inspect tab in inspection menu" do
    template = "."
    @world = WorldBuilder.new(template).build
    $inspection_menu = InspectionMenu.new(INSPECTION_MENU_WIDTH, INSPECTION_MENU_HEIGHT, WORLD_WIDTH)

    InspectGameMode.new.click(0, 0)

    expect($inspection_menu.active_tab).to be_a InspectionMenu::InspectTab
  end

  data = {
    "T" => "Tree",
    "B" => "Berries",
    "W" => "Woodcutter",
    "G" => "Gatherer",
    "S" => "Storage Zone"
  }

  data.each do |template_key, name|
    it "doesn't crash when inspecting #{name}" do
      template = template_key
      @world = WorldBuilder.new(template).build
      $inspection_menu = InspectionMenu.new(INSPECTION_MENU_WIDTH, INSPECTION_MENU_HEIGHT, WORLD_WIDTH)

      InspectGameMode.new.click(0, 0)
      expect($inspection_menu.active_tab.content.length).to eq 1
    end
  end

  it "hovers and unhovers safely" do
    template = "."
    @world = WorldBuilder.new(template).build
    InspectGameMode.new.hover(0, 0)
    InspectGameMode.new.unhover
  end
end
