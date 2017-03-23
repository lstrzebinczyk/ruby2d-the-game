class PutAction < Action::Base
  PUTTING_TIME = 5
  def initialize(to, character)
    @to        = to 
    @character = character
    @time_left = PUTTING_TIME
  end

  def update
    @time_left -= 1

    if @time_left == 0
      item = @character.get_item
      $map.put_item(@to.x, @to.y, item)
      end_action
    end
  end

  def close
  end
end
