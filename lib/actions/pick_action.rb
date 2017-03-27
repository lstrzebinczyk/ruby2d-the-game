# Make it one minute to pick something
class PickAction < Action::Base
  def initialize(from, character)
    @from      = from
    @character = character
    @time_left = 60
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      item = $map[@from.x, @from.y].get_item
      if $map[@from.x, @from.y].count == 0
        $map[@from.x, @from.y] = nil
      end

      @character.carry = item
      end_action
    end
  end
end

