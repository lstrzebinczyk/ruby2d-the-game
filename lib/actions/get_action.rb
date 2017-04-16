class GetAction < Action::Base
  def initialize(item_class, opts = {})
    @item_class = item_class
    @from       = opts[:from]
    @character  = opts[:character]
    @on_abandon = opts[:on_abandon]
    @time_left  = 5
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
        if map_object.is_a? Container
          @character.carry = map_object.get_something
        end
        end_action
      else
        abandon_action
      end
    end
  end
end

