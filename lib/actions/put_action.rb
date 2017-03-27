class PutAction < Action::Base
  def initialize(to, character, opts = {})
    @to        = to 
    @character = character
    @time_left = 1.minute
    @after_callback = opts[:after]
  end

  def update(seconds)
    @time_left -= seconds

    if @time_left <= 0
      item = @character.get_item
      $map.put_item(@to.x, @to.y, item)
      @after_callback.call
      end_action
    end
  end
end
