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

  it "doesn't cancel the job if job is taken" do
    template = "B"
    @world = WorldBuilder.new(template).build
    RemoveGameMode.new.click(0, 0)

    $job_list.jobs.first.taken = true

    RemoveGameMode.new.click(0, 0)

    expect($job_list.count).to eq(1)
    expect($job_list.jobs.first).to be_a (CutBerryBushJob)
  end

  it "hovers and unhovers safely" do
    template = "."
    @world = WorldBuilder.new(template).build
    RemoveGameMode.new.hover(0, 0)
    RemoveGameMode.new.unhover
  end
end