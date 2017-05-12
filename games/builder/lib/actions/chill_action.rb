class ChillAction < Action::Base
  def initialize(character)
    @character = character
    @time_left = (10 + rand(15)).minutes
  end

  def update(seconds)
    @time_left -= seconds
    if @time_left <= 0
      end_action
    end
  end
end
