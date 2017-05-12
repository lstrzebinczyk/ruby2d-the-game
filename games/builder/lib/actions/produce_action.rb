class ProduceAction < Action::Base
  def initialize(item_class, opts)
    @item_class = item_class
    @at        = opts[:at]
    @character = opts[:character]
    @time_left = 15.minutes
  end

  def start
    unless @at.has_stuff_required_for(@item_class)
      raise ArgumentError, "Can't produce the #{@item_class}"
    end
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      @at.produce(@item_class)
      end_action
    end
  end
end

