class PickAction < Action::Base
  PICKING_TIME = 5

  def initialize(from, character)
    @from      = from
    @character = character
    @time_left = PICKING_TIME
  end

  def update
    @time_left -= 1

    if @time_left == 0
      item = $map[@from.x, @from.y].get_item
      if $map[@from.x, @from.y].count == 0
        $map[@from.x, @from.y] = nil
      end

      @character.carry = item
      end_action
    end
  end

  def close
  end
end

