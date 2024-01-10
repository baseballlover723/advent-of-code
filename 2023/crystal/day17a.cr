require "pairing_heap"
require "../../base"

class Year2023::Day17a < Base
  DIRECTIONS = {north: 0, west: 1, south: 2, east: 3}

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
    max_y = maze.size.to_u8
    max_x = maze[0].size.to_u8
    f_x = max_x - 1
    f_y = max_y - 1
    queue = PairingHeap::Heap(UInt16, Tuple(UInt8, UInt8, Symbol, UInt8)).new
    queue.insert(f_x.to_u16 + f_y.to_u16, {0_u8, 0_u8, :east, 0_u8})
    seen = Array.new(max_y) { Array.new(max_x) { StaticArray(UInt8, 4).new(4_u8) } }

    while !queue.empty?
      heat, rest = queue.delete_min
      x, y, direction, count = rest
      return heat if x == f_x && y == f_y
      next if is_seen?(seen, x, y, direction, count)
      # puts "(#{x}, #{y}) #{direction} * #{count} => #{heat}"
      valid_new_locations(max_x, max_y, x, y, direction, count).each do |xx, yy, new_direction, new_count|
        new_heat = heat + maze[yy][xx] + calc_heat_mod(new_direction)
        queue.insert(new_heat, {xx, yy, new_direction, new_count})
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
    else
      raise "Invalid direction"
    end
  end

  def is_seen?(seen, x, y, direction, count)
    static_arr = seen[y][x]
    return true if count >= static_arr[DIRECTIONS[direction]]
    static_arr[DIRECTIONS[direction]] = count
    seen[y][x] = static_arr
    false
  end

  def valid_new_locations(max_x, max_y, x, y, direction, count)
    new_locations(x, y, direction, count).select do |xx, yy, new_direction, new_count|
      xx < max_x && yy < max_y && new_count <= 3
    end
  end

  def new_locations(x : UInt8, y : UInt8, direction, count : UInt8)
    case direction
    when :north
      { {x, y &- 1, direction, count + 1}, {x &- 1, y, :west, 1_u8}, {x &+ 1, y, :east, 1_u8} }
    when :west
      { {x &- 1, y, direction, count + 1}, {x, y &- 1, :north, 1_u8}, {x, y &+ 1, :south, 1_u8} }
    when :south
      { {x, y &+ 1, direction, count + 1}, {x &- 1, y, :west, 1_u8}, {x &+ 1, y, :east, 1_u8} }
    when :east
      { {x &+ 1, y, direction, count + 1}, {x, y &- 1, :north, 1_u8}, {x, y &+ 1, :south, 1_u8} }
    else
      raise "Invalid direction"
    end
  end

  def parse_input(input)
    input.split('\n').map do |str|
      str.chars.map(&.to_u8)
    end
  end
end

stop_if_not_script(__FILE__)
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
