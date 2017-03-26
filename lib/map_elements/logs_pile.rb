# TODO: Reorganise to be a regular Pile 
# TODO: That will just accept items from outside
# Not connected only to pile

class LogsPile
  def initialize(x, y, count = nil)
    @x          = x
    @y          = y
    if count.nil?
      count = 3 + rand(4) 
    end
    @logs = Array.new(count){ Log.new } 

    rerender
  end

  def count
    @logs.count
  end

  def remove
    @image && @image.remove
  end

  def can_carry_more?
    count < 6
  end

  def rerender
    remove
    unless count == 0
      @image = Image.new(@x * PIXELS_PER_SQUARE, @y * PIXELS_PER_SQUARE, "assets/nature/logs/#{count}.png")
    end
  end

  def get_item
    item = @logs.shift
    rerender
    item
  end

  def put(item)
    if item.is_a? Log
      @logs << item
      rerender
    else
      raise "You can't put #{item.class} to a log pile"
    end
  end

  def passable?
    true
  end
end
