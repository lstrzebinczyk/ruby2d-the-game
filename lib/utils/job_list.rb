class JobList
  attr_reader :jobs

  def initialize
    @jobs = []
  end

  def add(job)
    @jobs << job
  end

  def get_job(character)
    character.accepts_jobs.each do |job_type|
      available_job = @jobs.find do |job|
        job.available? and job.type == job_type
      end

      if available_job
        delete(available_job)
        return available_job
      end

      $structures.each do |structure|
        if structure.has_job?(job_type)
          return structure.get_job(job_type)
        end
      end

      $zones.each do |zone|
        if zone.has_job?(job_type)
          return zone.get_job(job_type)
        end
      end
    end
    nil
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
