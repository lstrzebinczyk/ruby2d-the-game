require "spec_helper"

describe "Test scenarios" do
  it "woodcutting scenario without fireplace" do
    WoodcuttingTestScenario.new(fireplace: false).run!
  end

  it "woodcutting scenario with fireplace" do
    WoodcuttingTestScenario.new(fireplace: true).run!
  end

  xit "berries gathering scenario" do
    BerriesGatheringTestScenario.new.run!
  end

  it "berries cutting scenario" do
    BerriesCuttingTestScenario.new.run!
  end

  it "looks for a new storage to put if initial was taken" do
    PuttingToOtherZoneTestScenario.new.run!
  end

  it "looks for a new storage to put if initial was taken" do
    PuttingOnGroundTestScenario.new.run!
  end
end
