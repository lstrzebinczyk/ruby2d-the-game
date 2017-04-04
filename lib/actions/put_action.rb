class PutAction < Action::Base
  def initialize(to, character, opts = {})
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
      if $map[@to.x, @to.y].nil? || $map[@to.x, @to.y].can_carry_more?(item.class)
        $map.put_item(@to.x, @to.y, item)
        end_action
      else
        @character.carry = item
        if available_zone
          spot = available_zone
          action = PutAction.new(spot, @character)
          replace_action(action)
        else
          spot = @character
          spot_near = $map.find_free_spot_near(@character)
          action = PutAction.new(spot_near, @character)
          new_job = CarryLogJob.new(from: spot_near)
          $job_list.add(new_job)

          replace_action(action)
        end
      end
    end
  end

  private

  def available_zone
    $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? Log }
  end
end

