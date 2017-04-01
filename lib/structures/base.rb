class Structure
  class Base
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
  end
end
