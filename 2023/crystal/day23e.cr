require "../../base"

class Year2023::Day23e < Base
  def solve(arg)
    maze = parse_input(arg)
    # puts "maze:"
    # maze.each do |row|
    #   puts row.map { |b| b ? '.' : '#' }.join
    # end
    max_y = (maze.size - 1).to_u8

    graph, start_distance, end_distance = calc_graph(maze, max_y)

    # puts "maze:"
    # maze.each_with_index do |row, y|
    #   puts row.map.with_index { |n, x| nodes[[x, y]] || |b| b ? '.' : '#' }.join
    # end
    # puts "graph: #{graph}"

    calc_longest_path(graph) * -1 + start_distance + end_distance
  end

  def calc_longest_path(graph)
    paths = [] of Int16
    queue = [{0_u8, Set(UInt8).new, 0_i16}]
    while !queue.empty?
      node, seen, steps = queue.shift
      # puts "node: #{node}, steps: #{steps}, seen: #{seen}, include?: #{seen.include?(node)}"
      if node == 1
        paths << steps
        next
      end
      seen << node
      # puts "before: #{graph[node]}"
      need_clone = false
      graph[node].each do |new_node, additional_steps|
        next if seen.includes?(new_node)
        if need_clone
          seen = seen.clone
        else
          need_clone = true
        end
        queue << {new_node, seen, steps + additional_steps}
      end
    end

    # puts "paths: #{paths.size}"
    paths.min
  end

  def calc_graph(maze, max_y)
    start_x, start_y, start_distance, start_direction = calc_start_path(maze)
    end_x, end_y, end_distance = calc_end_path(maze, max_y)

    new_id = 0_u8
    nodes = { {start_x, start_y} => new_id }
    edges = Hash(UInt8, Hash(UInt8, Int16)).new() { |hsh, k| hsh[k] = {} of UInt8 => Int16 }

    queue = get_valid_next_locations(maze, start_x, start_y, 1, start_direction, new_id)
    nodes[{end_x, end_y}] = new_id += 1

    while !queue.empty?
      x, y, steps, direction, last_id = queue.pop
      # puts "(#{x}, #{y}) #{direction}: #{steps}, last_id: #{last_id}, dir_val: #{dir_val}"
      id = nodes[{x, y}]?
      if id
        # puts "crossroad (seen): (#{x}, #{y}): #{last_id} -> #{id}, direction: #{direction}"
        edges[last_id][id] = -steps
        edges[id][last_id] = -steps
        next
      end

      locations = get_valid_next_locations(maze, x, y, steps + 1, direction, last_id)
      # puts "locations: #{locations}"
      if locations.size > 1
        nodes[{x, y}] = new_id += 1
        # puts "crossroad (new): (#{x}, #{y}): #{last_id} -> #{new_id}, direction: #{direction}"

        edges[last_id][new_id] = -steps
        edges[new_id][last_id] = -steps
        locations.map! do |xx, yy, _, new_direction, _|
          {xx, yy, 1_i16, new_direction, new_id}
        end
      end
      queue.concat(locations)
    end

    # puts "nodes.size: #{nodes.size}"

    {edges, start_distance, end_distance}
  end

  def calc_start_path(maze)
    x = maze[0].index(true).not_nil!.to_u8
    y = 0_u8
    steps = 0_i16
    direction = :south

    loop do
      # puts "(#{x}, #{y}) #{direction}: #{steps}"
      locations = get_valid_next_locations(maze, x, y, steps + 1, direction, nil)
      if locations.size > 1
        return {x, y, steps, direction}
      end
      x, y, steps, direction = locations[0]
    end
  end

  def calc_end_path(maze, max_y)
    x = maze[max_y].index(true).not_nil!.to_u8
    y = max_y
    steps = 0_i16
    direction = :north

    loop do
      # puts "(#{x}, #{y}) #{direction}: #{steps}"
      locations = get_valid_next_locations(maze, x, y, steps + 1, direction, nil)
      if locations.size > 1
        return {x, y, steps}
      end
      x, y, steps, direction = locations[0]
    end
  end

  def get_valid_next_locations(maze, x : UInt8, y : UInt8, new_steps : Int16, direction, last_id)
    get_next_locations(x, y, new_steps, direction, last_id).select do |xx, yy, _, _, _|
      maze[yy][xx]
    end
  end

  def get_next_locations(x : UInt8, y : UInt8, new_steps : Int16, direction, last_id)
    case direction
    when :north
      { {x, y - 1, new_steps, direction, last_id}, {x - 1, y, new_steps, :west, last_id}, {x + 1, y, new_steps, :east, last_id} }
    when :west
      { {x - 1, y, new_steps, direction, last_id}, {x, y - 1, new_steps, :north, last_id}, {x, y + 1, new_steps, :south, last_id} }
    when :south
      { {x, y + 1, new_steps, direction, last_id}, {x - 1, y, new_steps, :west, last_id}, {x + 1, y, new_steps, :east, last_id} }
    when :east
      { {x + 1, y, new_steps, direction, last_id}, {x, y - 1, new_steps, :north, last_id}, {x, y + 1, new_steps, :south, last_id} }
    else
      raise "Invalid direction"
    end
  end

  def parse_input(input)
    input.split('\n').map do |str|
      str.chars.map do |c|
        c != '#'
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
