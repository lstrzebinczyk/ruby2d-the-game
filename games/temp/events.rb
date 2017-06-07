require "ruby2d"

event_descriptor = on :mouse_down do
  puts "Mouse down event catched!"
end

puts event_descriptor

# off(event_descriptor)

show

