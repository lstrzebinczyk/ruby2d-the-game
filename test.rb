require 'ruby2d'

@fps_text = Text.new(15, 15, "fps: 0", 40, "fonts/arial.ttf")

update do
  fps = get(:fps)
  @fps_text.remove
  @fps_text.text = fps.to_s
  @fps_text.add
end

show
