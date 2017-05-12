class MilkAnimalJob
  def initialize(animal)
    @animal = animal
  end

  def type
    :milking
  end

  def available?
    @animal.milkable?
  end

  def target
    @animal
  end

  def start
    @animal.finish
    @animal.job = BeingMilkedJob.new
  end

  def action_for(character)
    MoveAction.new(character: character, near: @animal).then do
      MilkAction.new(@animal, character: character)
    end
  end

  def remove
  end
end
