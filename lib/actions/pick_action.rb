class PickAction < Action::Base
  def initialize(from, character)
    @from      = from
    @character = character
    @time_left = 1.minute
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      map_object = $map[@from.x, @from.y]
      if map_object and map_object.pickable?
        item = map_object.get_item
        if $map[@from.x, @from.y].count == 0
          $map[@from.x, @from.y] = nil
        end
        @character.carry = item
        end_action
      else
        abandon_action
      end
    end
  end
end

