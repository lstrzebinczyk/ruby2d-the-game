require_relative "./base"

class StorageZone < Zone::Base
  attr_reader :x, :y, :image
  attr_accessor :taken

  def initialize(x_range, y_range)
    @x_range = x_range
    @y_range = y_range
    @x = x_range.to_a.first
    @y = y_range.to_a.first
    @width  = x_range.last - x_range.first + 1
    @height = y_range.last - y_range.first + 1

    @image = Rectangle.new(
      @x * PIXELS_PER_SQUARE,
      @y * PIXELS_PER_SQUARE,
      @width * PIXELS_PER_SQUARE,
      @height * PIXELS_PER_SQUARE,
      [1, 1, 1, 0.2],
      ZIndex::ZONE
    )

    @image.remove
    @image.add
  end

  def empty_spot
    spot = self_fields.find do |arr|
      $map[arr[0], arr[1]].content.nil?
    end
    $map[spot[0], spot[1]] if spot
  end

  def get_job(job_type)
    if job_type == :haul
      if empty_spot
        barrel = self_fields.map do |field_arr|
          $map[field_arr[0], field_arr[1]].content
        end.keep_if do |map_elem|
          # TODO Make this more generic for containers later
          map_elem.is_a? Barrel and map_elem.accepts?(:food)
        end.first

        food = $map.spots_near(self).find do |spot|
          spot.content.is_a? Item and spot.content.category == :food
        end

        if barrel and food
          StoreJob.new(food, in: barrel)
        else
          crate = self_fields.map do |field_arr|
            $map[field_arr[0], field_arr[1]].content
          end.keep_if do |map_elem|
            # TODO Make this more generic for containers later
            map_elem.is_a? Crate and map_elem.accepts?(:material)
          end.first

          item = $map.spots_near(self).find do |spot|
            spot.content.is_a? Item and spot.content.category == :material
          end

          if crate and item
            StoreJob.new(item, in: crate)
          else
            item = $map.spots_near(self).find do |spot|
              spot.content.is_a? Item and $zones.find_all{|z| z.is_a? StorageZone }.none?{|zone| zone.contain?(spot.content) }
            end

            StoreJob.new(item) if item
          end
        end
      end
    end
  end
end
