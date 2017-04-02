require "spec_helper"

describe "Test scenarios" do
  it "woodcutting scenario without fireplace" do
    test_scenario = WoodcuttingTestScenario.new(fireplace: false)
    test_scenario.run!
  end

  it "woodcutting scenario with fireplace" do
    test_scenario = WoodcuttingTestScenario.new(fireplace: true)
    test_scenario.run!
  end
end
