require "ruby2d"

on :mouse_down do |e|
  puts "mouse down"
  puts e
end

on :mouse_up do |e|
  puts "mouse up"
  puts e
end

on :mouse_move do |e|
  puts :move
  puts e
end

show

