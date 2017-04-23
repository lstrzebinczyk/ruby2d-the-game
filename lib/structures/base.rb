class Structure
  class Base
    attr_reader :x, :y, :jobs

    def initialize(x, y, size)
      @x, @y = x, y
      @size  = size
    end

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
      @size || self.class.size
    end

    def get_job(type)
      if @jobs and @jobs.any?
        job = @jobs.find{|j| j.type == type and j.available? }
        @jobs.delete(job)
      end
    end

    def distance_to(other_structure)
      if other_structure.is_a? Structure::Base
        field_pairs = self_fields.product(other_structure.self_fields)
        distances = field_pairs.map do |fields_pair|
          x1 = fields_pair[0][0]
          y1 = fields_pair[0][1]
          x2 = fields_pair[1][0]
          y2 = fields_pair[1][1]

          (x1 - x2).abs + (y1 - y2).abs
        end

        distances.min
      else
        raise "Can't calculate distance to #{other_structure.class}"
      end
    end

    def update(time)
    end
  end
end
