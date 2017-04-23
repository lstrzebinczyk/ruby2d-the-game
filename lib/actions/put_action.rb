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
        if $map[@to.x, @to.y].content.is_a? Container
          $map[@to.x, @to.y].content.put(item)
        else
          spot_near = $map.free_spots_near(@character).first
          $map[spot_near.x, spot_near.y].content = item
        end
      else
        if $map[@to.x, @to.y].content.nil?
          $map[@to.x, @to.y].content = item
        else
          spot_near = $map.free_spots_near(@character).first
          $map[spot_near.x, spot_near.y].content = item
        end
      end
      end_action
    end
  end
end
