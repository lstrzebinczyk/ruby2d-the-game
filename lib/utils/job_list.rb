class JobList
  def initialize
    @jobs = []
  end

  def add(job)
    @jobs << job
  end

  def get_job
    @jobs.find do |job|
      job.free?
    end
  end

  def count
    @jobs.count
  end

  def cleanup
    @jobs.keep_if(&:free?)
  end

  def has?(new_job)
    @jobs.any? do |job|
      new_job.class == job.class and new_job.target == job.target
    end
  end
end
