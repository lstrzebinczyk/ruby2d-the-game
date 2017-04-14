# A* IMPLEMENTATION

class PathFinder
  class Node
    attr_reader :x, :y, :i, :g, :h, :f
    # x = x-position
    # y = y-position
    # i = parent index
    # g = cost from start to current node
    # h = cost from current node to destination
    # f = cost from start to destination going through the current node
    def initialize(x, y, i, g, h, f)
      @x = x
      @y = y
      @i = i
      @g = g
      @h = h
      @f = f
    end

    def set_g g
      @g = g
    end

    def set_h h
      @h = h
    end

    def set_f f
      @f = f
    end
  end

  def initialize(start, destination, map)
    # create start and destination nodes
    @start_node = Node.new(start.x,       start.y,       -1, -1, -1, -1)
    @dest_node  = Node.new(destination.x, destination.y, -1, -1, -1, -1)

    @map = map

    @open_nodes   = [] # conatins all open nodes (nodes to be inspected)
    @closed_nodes = [] # contains all closed nodes (node we've already inspected)

    @open_nodes.push(@start_node) # push the start node
  end

  # calc heuristic
  # Euclidean distance between points without sqrt and floor for speed
  # plus some randoms to make the paths bit more wacky and unpredicrable
  # this way they looks much nicer and less mechanical
  def heuristic(current_node, destination_node)
    make_positive(current_node.x - destination_node.x + rand) + make_positive(current_node.y - destination_node.y + rand)
  end

  def make_positive(value)
    value ** 2
  end

  # calc cost
  def cost(current_node, destination_node)
    direction = direction(current_node, destination_node)

    return 10 if [2, 4, 6, 8].include?(direction) # south, west, east, north
    return 14
  end

  # determine direction (2, 4, 6, 8)
  def direction(current_node, destination_node)
    direction = [ destination_node.y - current_node.y,  # down/up
                  destination_node.x - current_node.x ] # negative: left, positive: right

    return 2 if direction[0] > 0 and direction[1] == 0 # south
    return 4 if direction[1] < 0 and direction[0] == 0 # west
    return 8 if direction[0] < 0 and direction[1] == 0 # north
    return 6 if direction[1] > 0 and direction[0] == 0 # east

    return 0 # default
  end

  # field passable?
  def passable?(x, y)
    @map.passable?(x, y) and $characters_list.none?{|char| char.x == x and char.y == y }
  end

  # expand node in all 4 directions
  def expand(current_node)
    x   = current_node.x
    y   = current_node.y

    return [ [x, (y - 1)],  # north
             [x, (y + 1)],  # south
             [(x + 1), y],  # east
             [(x - 1), y] ] # west
  end

  def search
    while @open_nodes.size > 0 do
      # p @open_nodes
      # Map for now is infinite, so if search gets too big, we decide
      # That there is no good path
      if @closed_nodes.size > 2000
        return []
      end

      # grab the lowest f(x)
      low_i = 0
      for i in 0..@open_nodes.size-1
        if @open_nodes[i].f < @open_nodes[low_i].f then
          low_i = i
        end
      end
      best_node = low_i

      # set current node
      current_node = @open_nodes[best_node]

      # check if we've reached our destination
      if (current_node.x == @dest_node.x) and (current_node.y == @dest_node.y) then
        path = [@dest_node]

        # recreate the path
        while current_node.i != -1 do
          current_node = @closed_nodes[current_node.i]
          path.unshift(current_node)
        end

        return path
      end

      # remove the current node from open node list
      @open_nodes.delete_at(best_node)

      # and push onto the closed nodes list
      @closed_nodes.push(current_node)

      # expand the current node
      neighbor_nodes = expand(current_node)
      for n in 0..neighbor_nodes.size-1
        neighbor = neighbor_nodes[n]
        nx       = neighbor[0]
        ny       = neighbor[1]

        # if the new node is passable or our destination
        if (passable?(nx, ny) or (nx == @dest_node.x and ny == @dest_node.y)) then
          # check if the node is already in closed nodes list
          in_closed = false
          for j in 0..@closed_nodes.size-1
            closed_node = @closed_nodes[j]
            if nx == closed_node.x and ny == closed_node.y then
              in_closed = true
              break
            end
          end
          next if in_closed

          # check if the node is in the open nodes list
          # if not, use it!
          in_open = false
          for j in 0..@open_nodes.size-1
            open_node = @open_nodes[j]
            if nx == open_node.x and ny == open_node.y then
              in_open = true
              break
            end
          end

          unless in_open then
            new_node = Node.new(nx, ny, @closed_nodes.size-1, -1, -1, -1)

            # setup costs
            new_node.set_g(current_node.g + cost(current_node, new_node))
            new_node.set_h(heuristic(new_node, @dest_node))
            new_node.set_f(new_node.g + new_node.h)

            @open_nodes.push(new_node)
          end
        end
      end
    end

    return [] # return empty path
  end
end
