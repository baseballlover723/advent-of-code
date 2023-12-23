require 'fc'
require "./base"

DIRECTIONS = {north: 0, west: 1, south: 2, east: 3} unless defined? DIRECTIONS

def solve(arg)
  maze = parse_input(arg)
  # puts "maze: "
  # maze.each do |row|
  #   puts row.inspect
  # end

  min_heat = simulate_heat(maze)
  min_heat
end

def simulate_heat(maze)
  max_y = maze.size
  max_x = maze[0].size
  f_x = max_x - 1
  f_y = max_y - 1
  queue = FastContainers::PriorityQueue.new(:min)
  queue.push([0,0,:east, 0, f_x + f_y], f_x + f_y)
  seen = Array.new(max_y) { Array.new(max_x) { [4,4,4,4] } }

  while !queue.empty?
    x, y, direction, count, heat = queue.pop
    return heat if x == f_x && y == f_y
    next if is_seen?(seen, x, y, direction, count)
    # puts "(#{x}, #{y}) #{direction} * #{count} => #{heat}"
    valid_new_locations(max_x, max_y, x, y, direction, count).each do |xx, yy, new_direction, new_count|
      new_heat = heat + maze[yy][xx] + calc_heat_mod(new_direction)
      queue.push([xx, yy, new_direction, new_count, new_heat], new_heat)
    end
  end

  0
end

def calc_heat_mod(direction)
  case direction
  when :north, :west
    1
  when :south, :east
    -1
  end
end

def is_seen?(seen, x, y, direction, count)
  return true if count >= seen[y][x][DIRECTIONS[direction]]
  seen[y][x][DIRECTIONS[direction]] = count
  false
end

def valid_new_locations(max_x, max_y, x, y, direction, count)
  new_locations(x, y, direction, count).filter do |xx, yy, new_direction, new_count|
    xx >= 0 && xx < max_x && yy >= 0 && yy < max_y && new_count <= 3
  end
end

def new_locations(x, y, direction, count)
  case direction
  when :north
    [[x, y - 1, direction, count + 1], [x - 1, y, :west, 1], [x + 1, y, :east, 1]]
  when :west
    [[x - 1, y, direction, count + 1], [x, y - 1, :north, 1], [x, y + 1, :south, 1]]
  when :south
    [[x, y + 1, direction, count + 1], [x - 1, y, :west, 1], [x + 1, y, :east, 1]]
  when :east
    [[x + 1, y, direction, count + 1], [x, y - 1, :north, 1], [x, y + 1, :south, 1]]
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    str.chars.map(&:to_i)
  end
end

return if __FILE__ != $0
# test_run("2413432311323
# 3215453535623
# 3255245654254
# 3446585845452
# 4546657867536
# 1438598798454
# 4457876987766
# 3637877979653
# 4654967986887
# 4564679986453
# 1224686865563
# 2546548887735
# 4322674655533")
run(__FILE__)
