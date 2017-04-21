class PutAction < Action::Base
  def initialize(to, character, opts = {})
    @to           = to
    @character    = character
    @time_left    = 10
    @in_container = opts[:in_container]
  end

  # If you want to put your object down, but the space is already filled
  # Check if there is place in another storage and go there
  # And if there is not, just drop it wherever you can
  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      item = @character.get_item

      if @in_container
        if $map[@to.x, @to.y].is_a? Container
          $map[@to.x, @to.y].put(item)
        else
          spot_near = $map.find_empty_spot_near(@character)
          $map[spot_near.x, spot_near.y] = item
        end
      else
        if $map[@to.x, @to.y].nil?
          $map[@to.x, @to.y] = item
        else
          spot_near = $map.find_empty_spot_near(@character)
          $map[spot_near.x, spot_near.y] = item
        end
      end
      end_action
    end
  end
end

