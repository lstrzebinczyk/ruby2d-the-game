class PutAction < Action::Base
  def initialize(to, character)
    @to        = to
    @character = character
    @time_left = 10
  end

  # If you want to put your object down, but the space is already filled
  # Check if there is place in another storage and go there
  # And if there is not, just drop it wherever you can
  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      item = @character.get_item
      if $map[@to.x, @to.y].nil?
        $map.put_item(@to.x, @to.y, item)
      # elsif $map[@to.x, @to.y].is_a? Container
      #   $map[@to.x, @to.y].put(item)
      else
        spot_near = $map.find_empty_spot_near(@character)
        $map.put_item(spot_near.x, spot_near.y, item)
      end
      $zones.each do |zone|
        zone.free_taken(@to)
      end
      end_action
    end
  end
end

