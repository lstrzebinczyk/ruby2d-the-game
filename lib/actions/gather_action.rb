# TODO: Introduce some sort of tools to help gather
# TODO: Gather based not on time, but on how much a character can carry
class GatherAction < Action::Base
  def initialize(character, target)
    @character = character
    @target    = target
    @time_left = @target.gathering_time
  end

  def update(seconds)
    @time_left -= seconds

    # @character.carry += @berries_bush.get_berries(seconds)
    if @time_left <= 0
      @target.gather_all.each do |item|
        spot = $map.find_empty_spot_near(@target)
        $map.put_item(spot.x, spot.y, item)
      end

      @target.was_picked!
      end_action
    end
  end
end
