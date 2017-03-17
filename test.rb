require 'ruby2d'

@text = Text.new(15, 15, "yo", 40, "fonts/arial.ttf")

update do
  @text.text = 1
end

show
