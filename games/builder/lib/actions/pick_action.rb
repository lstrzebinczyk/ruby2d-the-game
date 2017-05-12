class PickAction < Action::Base
  def initialize(from, character, opts = {})
    @from       = from
    @character  = character
    @time_left  = 5
    @on_abandon = opts[:on_abandon]
    @get_from_container = opts[:get_from_container]
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
      map_object = $map[@from.x, @from.y].content

      if map_object
        if map_object.is_a? Container and @get_from_container
          @character.carry = map_object.get_something
        else
          @character.carry = map_object
          $map[@from.x, @from.y].clear_content
        end
        end_action
      else
        abandon_action
      end
    end
  end
end

