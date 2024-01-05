require "pairing_heap"
require "./base"

class Day23c < Base
  MAZE_CHARS         = {'#' => 5_u8, '.' => 4_u8, '^' => 0_u8, '<' => 1_u8, 'v' => 2_u8, '>' => 3_u8}
  REVERSE_MAZE_CHARS = MAZE_CHARS.invert
  DIRECTIONS         = {:north, :west, :south, :east}

  def solve(arg)
    maze = parse_input(arg)
    # puts "maze:"
    # maze.each do |row|
    #   puts row.map { |n| REVERSE_MAZE_CHARS[n] }.join
    # end
    max_y = (maze.size - 1).to_u8

    graph, nodes, start_distance, end_distance = calc_graph(maze, max_y)

    # puts "maze:"
    # maze.each_with_index do |row, y|
    #   puts row.map.with_index { |n, x| nodes[[x, y]] || REVERSE_MAZE_CHARS[n] }.join
    # end
    # puts "nodes: #{nodes}"
    # puts "graph: #{graph}"

    calc_longest_path(graph, nodes) * -1 + start_distance + end_distance
  end

  def calc_longest_path(graph, nodes)
    dist = nodes.map { |_| 0_i16 }
    queue = PairingHeap::Heap(Int16, UInt8).new
    queue.insert(0_i16, 0_u8)

    while !queue.empty?
      steps, node = queue.delete_min
      # puts "node: #{node}, steps: #{steps}, dist: #{dist}"
      # puts "before: #{graph[node]}"
      graph[node].each do |new_node, additional_steps|
        # puts "#{node} -> #{new_node}: #{additional_steps}"
        new_steps = steps + additional_steps
        if new_steps < dist[new_node]
          dist[new_node] = new_steps
          queue.insert(new_steps, new_node)
        end
      end
    end

    # puts "dist: #{dist}"
    dist[1]
  end

  def calc_graph(maze, max_y)
    start_x, start_y, start_distance, start_direction = calc_start_path(maze)
    end_x, end_y, end_distance = calc_end_path(maze, max_y)

    new_id = 0_u8
    nodes = { {start_x, start_y} => new_id }
    edges = Hash(UInt8, Hash(UInt8, Int16)).new() { |hsh, k| hsh[k] = {} of UInt8 => Int16 }

    queue = get_valid_next_locations(maze, start_x, start_y, 1_i16, start_direction, new_id, true)
    nodes[{end_x, end_y}] = new_id += 1_u8

    while !queue.empty?
      x, y, steps, direction, last_id, reversible = queue.pop
      dir_val = maze[y][x]
      # puts "(#{x}, #{y}) #{direction}: #{steps}, last_id: #{last_id}, reversible: #{reversible}, dir_val: #{dir_val}"
      next if dir_val != 4_u8 && DIRECTIONS[dir_val] != direction
      reversible = false if reversible && dir_val <= 3_u8
      id = nodes[{x, y}]?
      if id
        # puts "crossroad (seen): (#{x}, #{y}): #{last_id} -> #{id}, direction: #{direction}, reversible: #{reversible}"
        edges[last_id][id] = -steps
        edges[id][last_id] = -steps if reversible
        next
      end

      locations = get_valid_next_locations(maze, x, y, steps + 1, direction, last_id, reversible)
      # puts "locations: #{locations}"
      if locations.size > 1
        nodes[{x, y}] = new_id += 1
        # puts "crossroad (new): (#{x}, #{y}): #{last_id} -> #{new_id}, direction: #{direction}, reversible: #{reversible}"

        edges[last_id][new_id] = -steps
        edges[new_id][last_id] = -steps if reversible
        locations.map! do |xx, yy, _, new_direction, _, _|
          {xx, yy, 1_i16, new_direction, new_id, true}
        end
      end
      queue.concat(locations)
    end

    {edges, nodes, start_distance, end_distance}
  end

  def calc_start_path(maze)
    x = maze[0].index(4).not_nil!.to_u8
    y = 0_u8
    steps = 0_i16
    direction = :south

    loop do
      # puts "(#{x}, #{y}) #{direction}: #{steps}"
      locations = get_valid_next_locations(maze, x, y, steps + 1, direction, nil, false)
      if locations.size > 1
        return {x, y, steps, direction}
      end
      x, y, steps, direction = locations[0]
    end
  end

  def calc_end_path(maze, max_y)
    x = maze[max_y].index(4).not_nil!.to_u8
    y = max_y
    steps = 0_i16
    direction = :north

    loop do
      # puts "(#{x}, #{y}) #{direction}: #{steps}"
      locations = get_valid_next_locations(maze, x, y, steps + 1, direction, nil, false)
      if locations.size > 1
        return {x, y, steps}
      end
      x, y, steps, direction = locations[0]
    end
  end

  def get_valid_next_locations(maze, x : UInt8, y : UInt8, new_steps : Int16, direction, last_id, reversible)
    get_next_locations(x, y, new_steps, direction, last_id, reversible).select do |xx, yy, _, _, _, _|
      maze[yy][xx] <= 4_u8
    end
  end

  def get_next_locations(x : UInt8, y : UInt8, new_steps : Int16, direction, last_id, reversible)
    case direction
    when :north
      { {x, y - 1, new_steps, direction, last_id, reversible}, {x - 1, y, new_steps, :west, last_id, reversible}, {x + 1, y, new_steps, :east, last_id, reversible} }
    when :west
      { {x - 1, y, new_steps, direction, last_id, reversible}, {x, y - 1, new_steps, :north, last_id, reversible}, {x, y + 1, new_steps, :south, last_id, reversible} }
    when :south
      { {x, y + 1, new_steps, direction, last_id, reversible}, {x - 1, y, new_steps, :west, last_id, reversible}, {x + 1, y, new_steps, :east, last_id, reversible} }
    when :east
      { {x + 1, y, new_steps, direction, last_id, reversible}, {x, y - 1, new_steps, :north, last_id, reversible}, {x, y + 1, new_steps, :south, last_id, reversible} }
    else
      raise "Invalid direction"
    end
  end

  def parse_input(input)
    input.split('\n').map do |str|
      str.chars.map do |c|
        MAZE_CHARS[c]
      end
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("#.#####################
# #.......#########...###
# #######.#########.#.###
# ###.....#.>.>.###.#.###
# ###v#####.#v#.###.#.###
# ###.>...#.#.#.....#...#
# ###v###.#.#.#########.#
# ###...#.#.#.......#...#
# #####.#.#.#######.#.###
# #.....#.#.#.......#...#
# #.#####.#.#.#########v#
# #.#...#...#...###...>.#
# #.#.#v#######v###.###v#
# #...#.>.#...>.>.#.###.#
# #####v#.#.###v#.#.###.#
# #.....#...#...#.#.#...#
# #.#########.###.#.#.###
# #...###...#...#...#.###
# ###.###.#.###v#####v###
# #...#...#.#.>.>.#.>.###
# #.###.###.#.###.#.#v###
# #.....###...###...#...#
# #####################.#")
run(__FILE__)
