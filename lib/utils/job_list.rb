class JobList
  def initialize
    @jobs = []
  end

  def add(job)
    @jobs << job
  end

  def get_job
    @jobs.find do |job|
      job.free? and job.available?
    end
  end

  def count
    @jobs.count
  end

  def find(job_class, job_target)
    @jobs.find{|j| j.class == job_class and j.target == job_target }
  end

  def delete(job)
    @jobs.delete(job)
  end

  def has?(job_class, job_target)
    @jobs.any? do |job|
      job.class == job_class and job.target == job_target
    end
  end
end
