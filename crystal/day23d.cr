require "./base"

class Day23d < Base
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

    paths = find_paths(maze, max_y)

    # puts "paths: #{paths}"

    paths.max
  end

  def find_paths(maze, max_y)
    paths = [] of Int16
    queue = [{maze[0].index(4).not_nil!.to_u8, 0_u8, 0_i16, :south}]
    end_x, end_y, end_distance = calc_end_path(maze, max_y)

    while !queue.empty?
      x, y, steps, direction = queue.shift
      # puts "(#{x}, #{y}) #{direction}: #{steps}"
      if x == end_x && y == end_y
        paths << steps + end_distance
        next
      end

      locations = get_valid_next_locations(maze, x, y, steps + 1, direction)
      # puts "locations: #{locations}"
      queue.concat(locations)
    end

    paths
  end

  def calc_end_path(maze, max_y)
    x = maze[max_y].index(4).not_nil!.to_u8
    y = max_y
    steps = 0_i16
    direction = :north

    loop do
      # puts "(#{x}, #{y}) #{direction}: #{steps}"
      locations = get_next_locations(x, y, steps + 1, direction).select do |xx, yy, _, _|
        maze[yy][xx] <= 4
      end
      if locations.size > 1
        return {x, y, steps}
      end
      x, y, steps, direction = locations[0]
    end
  end

  def get_valid_next_locations(maze, x : UInt8, y : UInt8, new_steps : Int16, direction)
    get_next_locations(x, y, new_steps, direction).select do |xx, yy, _, new_direction|
      val = maze[yy][xx]
      next false if val >= 5_u8
      # puts "val: #{val}, new_direction: #{new_direction}"
      val == 4_u8 || DIRECTIONS[val] == new_direction
    end
  end

  def get_next_locations(x : UInt8, y : UInt8, new_steps : Int16, direction)
    case direction
    when :north
      { {x, y - 1, new_steps, direction}, {x - 1, y, new_steps, :west}, {x + 1, y, new_steps, :east} }
    when :west
      { {x - 1, y, new_steps, direction}, {x, y - 1, new_steps, :north}, {x, y + 1, new_steps, :south} }
    when :south
      { {x, y + 1, new_steps, direction}, {x - 1, y, new_steps, :west}, {x + 1, y, new_steps, :east} }
    when :east
      { {x + 1, y, new_steps, direction}, {x, y - 1, new_steps, :north}, {x, y + 1, new_steps, :south} }
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
