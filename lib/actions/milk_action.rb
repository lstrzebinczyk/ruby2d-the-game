class MilkAction < Action::Base
  def initialize(animal, opts)
    @animal = animal
    @character = opts[:character]

    # TODO: It should take 30 minutes for somebody unskilled
    # TODO: but for somebody skilled it's 5 minutes
    @time_left = 30.minutes
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      # Animals job should be BeingMilkedJob, we must end it when we're done
      @animal.was_milked!
      @animal.finish

      empty_spot = $map.free_spots_near(@animal).first

      bucket_of_milk = BucketOfMilk.new(empty_spot.x, empty_spot.y)
      $map[empty_spot.x, empty_spot.y].content = bucket_of_milk

      end_action
    end
  end
end

