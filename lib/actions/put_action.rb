class PutAction < Action::Base
  def initialize(to, character, opts = {})
    @to        = to
    @character = character
    @time_left = 1.minute
    @after_callback = opts[:after]
  end

  # If you want to put your object down, but the space is already filled
  # Check if there is place in another storage and go there
  # And if there is not, just drop it wherever you can
  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      if $map[@to.x, @to.y].nil? || $map[@to.x, @to.y].can_carry_more?
        item = @character.get_item
        $map.put_item(@to.x, @to.y, item)
        @after_callback.call
        end_action
      else
        spot = nil
        if available_zone
          spot = available_zone
        else
          spot = @character
        end

        spot_near = $map.find_free_spot_near(spot)
        action = PutAction.new(spot_near, @character, after: @after_callback)

        new_job = CarryLogJob.new(from: spot_near)
        $job_list.add(new_job)

        replace_action(action)
      end
    end
  end

  private

  def available_zone
    $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? LogsPile }
  end
end

