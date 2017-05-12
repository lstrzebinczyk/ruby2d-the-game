class Zone
  class Base
    def include_any?(fields)
      fields.any? do |f|
        self_fields.include?(f)
      end
    end

    def self_fields
      @self_fields ||= begin
        @x_range.to_a.product(@y_range.to_a)
      end
    end

    def contain?(object)
      @x_range.cover?(object.x) and @y_range.cover?(object.y)
    end
  end
end
