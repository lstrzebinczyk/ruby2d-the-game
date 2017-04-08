class BuildAction < Action::Base
  def initialize(structure, character)
    @character = character
    @structure = structure
    @time_left = structure.building_time
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      @structure.finished_building!
      end_action
    end
  end
end
