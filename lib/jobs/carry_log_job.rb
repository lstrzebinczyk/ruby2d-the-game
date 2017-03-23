class CarryLogJob
  attr_writer :taken

  def initialize(opts)
    @from = opts[:from]
    # @to   = opts[:to]

    @taken = false
  end

  def free?
    !@taken
  end

  def available?
    !!available_zone
  end

  def available_zone
    $zones.find{|zone| zone.is_a? StorageZone and zone.has_place_for? LogsPile }
  end

  def target
    @from
    # [@from, @to]
  end

  # - go to spot near @to 
  # - pick one log from there
  #   - if this was the last one, clear the spot 
  # - move to spot near @to 
  # - put the log to @to

  def action_for(character)
    to = available_zone
    spot_near_from = $map.find_free_spot_near(@from)
    spot_near_to   = $map.find_free_spot_near(to)

    MoveAction.new(character, spot_near_from, character).then do
      PickAction.new(@from, character)
    end.then do 
      MoveAction.new(spot_near_from, spot_near_to, character)
    end.then do 
      PutAction.new(to, character)
    end
  end

#   def action_for(character)
#     target_position = $map.find_free_spot_near(@tree)
#     MoveAction.new(character, target_position, character).then do
#       action = CutTreeAction.new(@tree, character)
#       action.job = self
#       action
#     end
#   end

  def remove
    $job_list.delete(self)
  end 
end

# CarryLogJob.new(from: @tree, to: available_zone)

# class CutTreeJob
#   attr_writer :taken

#   def initialize(tree)
#     @tree = tree
#     x = tree.x * PIXELS_PER_SQUARE
#     y = tree.y * PIXELS_PER_SQUARE

#     @taken = false

#     @mask = Square.new(x, y, PIXELS_PER_SQUARE, [1, 0, 0, 0.2])
#   end

#   def inspect
#     "#<CutTreeJob @y=#{@tree.y}, @x=#{@tree.x}, @taken=#{@taken}>"
#   end

#   def free?
#     !@taken
#   end

#   def target
#     @tree
#   end

#   def action_for(character)
#     target_position = $map.find_free_spot_near(@tree)
#     MoveAction.new(character, target_position, character).then do
#       action = CutTreeAction.new(@tree, character)
#       action.job = self
#       action
#     end
#   end

#   def remove
#     @mask.remove
#     @taken    = true

#     $job_list.delete(self)
#   end
# end
