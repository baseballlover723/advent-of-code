require "pairing_heap"
require "./base"

class Day17b < Base
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
    queue.insert(f_x.to_u16 + f_y.to_u16 - 1 + maze[0][1], {1_u8, 0_u8, :east, 1_u8})
    # queue.insert(f_x + f_y, {0, 0, :south, 0, f_x + f_y})
    seen = Array.new(max_y) { Array.new(max_x) { StaticArray(StaticArray(UInt8 | Bool, 4), 4).new(StaticArray[11_u8, false, false, false]) } }
    # puts "final: (#{f_x}, #{f_y})"

    while !queue.empty?
      heat, rest = queue.delete_min
      x, y, direction, count = rest
      # puts "\n(#{x}, #{y}) #{direction} * #{count} => #{heat}"
      return heat if count >= 4 && x == f_x && y == f_y
      next if is_seen?(seen, x, y, direction, count)
      # puts "(#{x}, #{y}) #{direction} * #{count} => #{heat}"
      valid_new_locations(max_x, max_y, x, y, direction, count).each do |xx, yy, new_direction, new_count|
        # puts "new_location: (#{xx}, #{yy}) #{new_direction}: #{new_count}"
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
    # puts "(#{x}, #{y}) #{direction} * #{count}"
    if count < 4
      b = seen[y][x][DIRECTIONS[direction]][count].as(Bool)
      # puts "b: #{b}"
      static_arr = seen[y][x]
      static_arr2 = static_arr[DIRECTIONS[direction]]
      static_arr2[count] = true
      static_arr[DIRECTIONS[direction]] = static_arr2
      seen[y][x] = static_arr
      b
    else
      # puts "count: #{count}, seen[y][x][DIRECTIONS[direction]][0]: #{seen[y][x][DIRECTIONS[direction]][0]}"
      static_arr = seen[y][x]
      static_arr2 = static_arr[DIRECTIONS[direction]]
      return true if count >= static_arr2[0].as(UInt8)
      static_arr2[0] = count
      static_arr[DIRECTIONS[direction]] = static_arr2
      seen[y][x] = static_arr
      false
    end
  end

  def valid_new_locations(max_x, max_y, x, y, direction, count)
    new_locations(x, y, direction, count).select do |xx, yy, new_direction, new_count|
      xx < max_x && yy < max_y && new_count <= 10
    end
  end

  def new_locations(x, y, direction, count)
    case direction
    when :north
      if count < 4
        { {x, y &- 1, direction, count + 1} }
      else
        { {x, y &- 1, direction, count + 1}, {x &- 1, y, :west, 1_u8}, {x &+ 1, y, :east, 1_u8} }
      end
    when :west
      if count < 4
        { {x &- 1, y, direction, count + 1} }
      else
        { {x &- 1, y, direction, count + 1}, {x, y &- 1, :north, 1_u8}, {x, y &+ 1, :south, 1_u8} }
      end
    when :south
      if count < 4
        { {x, y &+ 1, direction, count + 1} }
      else
        { {x, y &+ 1, direction, count + 1}, {x &- 1, y, :west, 1_u8}, {x &+ 1, y, :east, 1_u8} }
      end
    when :east
      if count < 4
        { {x &+ 1, y, direction, count + 1} }
      else
        { {x &+ 1, y, direction, count + 1}, {x, y &- 1, :north, 1_u8}, {x, y &+ 1, :south, 1_u8} }
      end
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
# test_run("111111111111
# 999999999991
# 999999999991
# 999999999991
# 999999999991")
run(__FILE__)
