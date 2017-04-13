class SetStorageGameMode < GameMode::Base::Area
  def perform(in_game_x_range, in_game_y_range)
    in_game_x_range.each do |x|
      in_game_y_range.each do |y|
        if $zones[x, y].nil?
          unless $map[x, y].is_a? River
            $zones[x, y] = StorageZone.new(x, y)
            if $map[x, y]
              $map[x, y].rerender
            end
          end
        end
      end
    end
  end
end
