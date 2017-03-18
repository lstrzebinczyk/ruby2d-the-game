class Path
  def initialize
    @nodes            = []
    @shapes_to_render = []
  end

  def any?
    @nodes.any?
  end

  def update(nodes)
    @nodes = nodes
    rerender
  end

  def shift_node
    remove
    node_to_shift = @nodes.shift
    render
    node_to_shift
  end

  def remove
    @shapes_to_render.each(&:remove)
  end

  private

  def rerender
    remove
    render
  end

  def render
    @shapes_to_render = []

    @nodes.each do |node|
      x = node.x * PIXELS_PER_SQUARE + PIXELS_PER_SQUARE / 4
      y = node.y * PIXELS_PER_SQUARE + PIXELS_PER_SQUARE / 4
      shape = Square.new(x, y, PIXELS_PER_SQUARE / 2, 'red')
      @shapes_to_render << shape
    end

    $character.rerender
  end
end
