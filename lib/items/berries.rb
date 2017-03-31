# This represents a handful of berries 
# Later this will be restricted to how many can be transported with hand 
# Some sort of sack or something will be needed 
# TODO TODO TODO: MAKE THIS MORE REAL

class Berries < Item
  attr_reader :grams

  def initialize(grams)
    @grams = grams
  end

  # 148g (a cup) -> 84.4 calories
  # 1g -> 0.57
  def calories_per_gram
    0.57
  end

  # assume 5 minutes for cup (148 gram)
  # thats 5 * 60 / 148 grams eaten per second
  def grams_eaten_per_second
    2.027
  end

  def +(other)
    if other.is_a? Berries
      Berries.new(grams + other.grams)
    else
      raise "Uh-uh, I did a booboo"
    end
  end

  def calories_eaten_in(seconds)
    grams_eaten = seconds * grams_eaten_per_second
    @grams -= grams_eaten
    grams_eaten * calories_per_gram
  end

  def empty?
    @grams <= 0
  end
end
