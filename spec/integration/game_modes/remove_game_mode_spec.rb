require "spec_helper"

describe "RemoveGameMode" do
  it "adds job to cut the tree to jobs list" do
    template = "B"
    @world = WorldBuilder.new(template).build
    RemoveGameMode.new.click(0, 0)

    expect($job_list.count).to eq(1)
    expect($job_list.jobs.first).to be_a (CutBerryBushJob)
  end

  it "cancels the job if used for second time" do
    template = "B"
    @world = WorldBuilder.new(template).build
    RemoveGameMode.new.click(0, 0)
    RemoveGameMode.new.click(0, 0)

    expect($job_list.count).to eq(0)
  end

  it "hovers and unhovers safely" do
    template = "."
    @world = WorldBuilder.new(template).build
    RemoveGameMode.new.hover(0, 0)
    RemoveGameMode.new.unhover
  end

  it "forbids me to add new job if somebody is already performing this job" do
    template = "BW"
    @world = WorldBuilder.new(template).build
    RemoveGameMode.new.click(0, 0)

    @world.update

    # Character took the cut job
    expect($characters_list.first.job).to be

    RemoveGameMode.new.click(0, 0)

    expect($job_list.count).to eq(0)
  end
end
