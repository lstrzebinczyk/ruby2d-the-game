class JobList
  def initialize
    @jobs = []
  end

  def add(job)
    @jobs << job
  end

  def get_job
    @jobs.shift
  end
end
