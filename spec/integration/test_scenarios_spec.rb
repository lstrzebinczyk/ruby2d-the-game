require "spec_helper"

describe "Test scenarios" do
  it "woodcutting scenario" do
    test_scenario = WoodcuttingTestScenario.new
    test_scenario.run!
  end
end
