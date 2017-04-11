class PickAction < Action::Base
  def initialize(from, character, opts = {})
    @from       = from
    @character  = character
    @time_left  = 5
    @on_abandon = opts[:on_abandon]
  end

  def start
    thing = $map[@from.x, @from.y]
    if thing.nil?
      puts "Abandoning picking of #{thing}"
      if @on_abandon
        @on_abandon.call
      end
      abandon_action
    end
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      map_object = $map[@from.x, @from.y]

      if map_object
        @character.carry = map_object
        map_object.remove
        $map[@from.x, @from.y] = nil

        end_action
      else
        abandon_action
      end
    end
  end
end

