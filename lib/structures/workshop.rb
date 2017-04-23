$workshop_button_actions_set = {

}

class Workshop < Structure::Base
  class Inspection
    def initialize(workshop, opts = {})
      x = opts[:x]
      y = opts[:y]
      @buttons = []
      @texts = []
      @texts << Text.new(x, y, "Workshop", 16, "fonts/arial.ttf")

      padding = workshop.class.buildable_items.map{|item_class| item_class.name.size }.max

      workshop.class.buildable_items.each_with_index do |item_class, index|
        count = workshop.jobs.count{|j| j.is_a? ProduceJob and j.item_class == item_class }
        message = "#{item_class.name.ljust(padding)}: #{count}"
        @texts << Text.new(x, y + 20 * (index + 1), message, 16, "fonts/arial.ttf")

        button = Button.new("+",
          side_padding: 4,
          inactive_color: "green",
          text_size: 10,
          top_and_bottom_padding: 4
        )
        button.render(x + @texts.last.width + 10, @texts.last.y)
        unless $workshop_button_actions_set[item_class]
          on_click_callback = -> {
            workshop.request(item_class)
          }
          button.on_click = on_click_callback
          $workshop_button_actions_set[item_class] = true
        end
        @buttons << button
      end

      @buttons.each(&:rerender)
    end

    def remove
      @texts.each(&:remove)
      @buttons.each(&:remove)
    end
  end

  attr_reader :x, :y, :supplies

  def self.structure_requirements
    [Log]
  end

  def self.building_time
    20.minutes
  end

  def self.size
    3
  end

  def self.buildable_items
    [Table, Barrel, Crate]
  end

  def initialize(x, y)
    @x, @y = x, y
    @size  = self.class.size

    @mask = Square.new(x * PIXELS_PER_SQUARE, y * PIXELS_PER_SQUARE, @size * PIXELS_PER_SQUARE, "green")
    @mask.color.opacity = 0.6

    @jobs     = []
    @supplies = []
  end

  # TODO: THis must be handled better if there will be duplications
  # like [Log, Log]
  def has_stuff_required_for(item_class)
    item_class.required_supplies.each do |requirement|
      @supplies.any?{|s| s.is_a? requirement }
    end
  end

  def request(item_class)
    item_class.required_supplies.each do |supply|
      @jobs << SupplyJob.new(supply, to: self)
    end
    @jobs << ProduceJob.new(item_class, at: self)
  end

  def produce(item_class)
    item_class.required_supplies.each do |requirement|
      supply = @supplies.find{|el| el.is_a? requirement}
      @supplies.delete(supply)
    end
    spot = $map.free_spots_near(self).first
    $map[spot.x, spot.y].content = item_class.new(spot.x, spot.y)
    nil
  end

  def supply(item)
    @supplies << item
  end
end
