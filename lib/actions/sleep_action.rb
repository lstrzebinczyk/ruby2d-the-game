class SleepAction < Action::Base
  def initialize(character)
    @character = character
    @energy_per_second = 2.3 * 0.00104167 / 60
    @seconds_left = 8 * 60 * 60 # 8 hours sleep, always. For now.
  end

  # def energy_per_minute_when_sleeping
  #   # this will be ok for a sleep in sort-of-good conditions
  #   # 3 * 0.00104167

  #   # sleeping on floor is way less refreshing
  # THESE ARE PER MINUTE
  #   2.3 * 0.00104167 # FIREPLACE
    # 2.6 * 0.00104167 # DORMITORY
    # 3.0 * 0.00104167 # OWN BED
  # end



  # FOR NOW SLEEP STRAIGHT FOR 8 HOURS
  # TODO: when sleeping, have the character sleep always till 6am when rested enough
  # when not rested enough, have a chance of waking up, growing between 6 am and 9am gradually

  def update(seconds)
    unless @character.state == :sleeping
      @character.state = :sleeping
    end

    @character.energy += @energy_per_second * seconds
    @seconds_left     -= seconds

    puts "sleeping"

    if @seconds_left <= 0
      @character.state = :working
      end_action
    end
  end
end


# class TheGame
#   class Action
#     class Sleep < Action
#       def initialize(place)
#         @place = place
#         @minutes_left = 8 * 60
#       end

#       def description
#         "sleeping in #{@place.description}"
#       end

#       def perform(person, map, time_in_minutes)
#         person.energy += @place.energy_per_minute_when_sleeping * time_in_minutes
#         @minutes_left -= time_in_minutes
#       end

#       def done?(person)
#         @minutes_left == 0
#       end
#     end
#   end
# end
