class ProduceAction < Action::Base
  def initialize(item_type, opts)
    @item_type = item_type
    @at        = opts[:at]
    @character = opts[:character]
    @time_left = 15.minutes
  end

  def start
    unless @at.has_stuff_required_for(@item_type)
      raise ArgumentError, "Can't produce the #{@item_type}"
    end
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      @at.produce(@item_type)
      end_action
    end
  end
end

