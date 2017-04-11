class Structure
  class Base
    attr_reader :jobs

    def include_any?(fields)
      fields.any? do |f|
        self_fields.include?(f)
      end
    end

    def self_fields
      @self_fields ||= begin
        x_range = (x..(x+size - 1))
        y_range = (y..(y+size - 1))

        x_range.to_a.product(y_range.to_a)
      end
    end

    def size
      self.class.size
    end

    def has_job?(type)
      @jobs.any?{|j| j.type == type and j.available? }
    end

    def get_job(type)
      job = @jobs.find{|j| j.type == type and j.available? }
      @jobs.delete(job)
    end

    def update(time)
    end

    def passable?
      true
    end
  end
end
