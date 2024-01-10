require_relative "../../base"

MAZE_CHARS = {'#' => 5, '.' => 4, '^' => 0, '<' => 1, 'v' => 2, '>' => 3} unless defined? MAZE_CHARS
REVERSE_MAZE_CHARS = MAZE_CHARS.invert unless defined? REVERSE_MAZE_CHARS
DIRECTIONS_ARR = [:north, :west, :south, :east] unless defined? DIRECTIONS_ARR

def solve(arg)
  maze = parse_input(arg)
  # puts "maze:"
  # maze.each do |row|
  #   puts row.map { |n| REVERSE_MAZE_CHARS[n] }.join
  # end
  max_y = maze.size - 1

  paths = find_paths(maze, max_y)

  # puts "paths: #{paths}"

  paths.max
end

def find_paths(maze, max_y)
  paths = []
  queue = [[maze[0].index(4), 0, 0, :south]]
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
  x = maze[max_y].index(4)
  y = max_y
  steps = 0
  direction = :north

  loop do
    # puts "(#{x}, #{y}) #{direction}: #{steps}"
    locations = get_next_locations(x, y, steps + 1, direction).select do |xx, yy, _, _|
      maze[yy][xx] <= 4
    end
    if locations.size > 1
      return [x, y, steps]
    end
    x, y, steps, direction = locations[0]
  end
end

def get_valid_next_locations(maze, x, y, new_steps, direction)
  get_next_locations(x, y, new_steps, direction).select do |xx, yy, _, new_direction|
    val = maze[yy][xx]
    next false if val >= 5
    # puts "val: #{val}, new_direction: #{new_direction}"
    val == 4 || DIRECTIONS_ARR[val] == new_direction
  end
end

def get_next_locations(x, y, new_steps, direction)
  case direction
  when :north
    [[x, y - 1, new_steps, direction], [x - 1, y, new_steps, :west], [x + 1, y, new_steps, :east]]
  when :west
    [[x - 1, y, new_steps, direction], [x, y - 1, new_steps, :north], [x, y + 1, new_steps, :south]]
  when :south
    [[x, y + 1, new_steps, direction], [x - 1, y, new_steps, :west], [x + 1, y, new_steps, :east]]
  when :east
    [[x + 1, y, new_steps, direction], [x, y - 1, new_steps, :north], [x, y + 1, new_steps, :south]]
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    str.chars.map do |c|
      MAZE_CHARS[c]
    end
  end
end

return if __FILE__ != $0
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
