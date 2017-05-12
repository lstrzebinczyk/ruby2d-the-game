class SupplyAction < Action::Base
  def initialize(to, character)
    @to        = to
    @character = character
    @time_left = 10
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      item = @character.get_item
      @to.supply(item)
      end_action
    end
  end
end

