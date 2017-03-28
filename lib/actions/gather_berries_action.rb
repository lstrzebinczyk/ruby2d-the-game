class GatherBerriesAction < Action::Base
  def initialize(character, berries_bush)
    @character    = character 
    @berries_bush = berries_bush
    @time_left    = 30.minutes
  end

  # TODO: have the gathering happen every update
  # TODO: So were not in situation where 2 people can get whole 30 minutes worth of berries 
  # TODO: When they're gathering together

  # TODO: HAVE start method in actions!
  def update(seconds)
    @time_left -= seconds

    @character.carry ||= Berries.new(0)
    @character.carry += @berries_bush.get_berries(seconds)
    if @time_left <= 0 
      end_action
    end
  end
end
