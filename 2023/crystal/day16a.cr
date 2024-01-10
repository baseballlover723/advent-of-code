require "../../base"

class Year2023::Day16a < Base
  DIRECTIONS = {north: 0, west: 1, south: 2, east: 3}

  def solve(arg)
    matrix = parse_input(arg)
    # puts "matrix: "
    # matrix.each do |row|
    #   puts row.join
    # end

    max_y = matrix.size
    max_x = matrix[0].size

    simulate_beams(matrix, max_y, max_x, {0, 0, :east})
  end

  def simulate_beams(matrix, max_y, max_x, start)
    bools = Array.new(max_y) { Array.new(max_x) { StaticArray(Bool, 4).new(false) } }
    queue = [start]

    while !queue.empty?
      x, y, direction = queue.shift
      next if x < 0 || x >= max_x || y < 0 || y >= max_y
      bool_arr = bools[y][x]
      next if bool_arr[DIRECTIONS[direction]]
      bool_arr[DIRECTIONS[direction]] = true
      bools[y][x] = bool_arr
      # puts "index: #{DIRECTIONS[direction]}, bool_arr[DIRECTIONS[direction]]: #{bool_arr[DIRECTIONS[direction]]}"
      case matrix[y][x]
      when '.'
        queue << get_next_tuple(x, y, direction)
      when '\\'
        queue << handle_forward_slash(x, y, direction)
      when '/'
        queue << handle_backward_slash(x, y, direction)
      when '-'
        case direction
        when :east, :west
          queue << get_next_tuple(x, y, direction)
        when :north, :south
          queue << get_next_tuple(x, y, :west)
          queue << get_next_tuple(x, y, :east)
        end
      when '|'
        case direction
        when :north, :south
          queue << get_next_tuple(x, y, direction)
        when :east, :west
          queue << get_next_tuple(x, y, :north)
          queue << get_next_tuple(x, y, :south)
        end
      end
    end

    # puts "bools: "
    # bools.each do |row|
    #   puts row.map {|b| b ? '#' : '.'}.join
    # end
    energized = bools.sum do |row|
      row.sum { |b| b.any? ? 1 : 0 }
    end

    energized
  end

  def handle_backward_slash(x, y, direction)
    case direction
    when :north
      get_next_tuple(x, y, :east)
    when :south
      get_next_tuple(x, y, :west)
    when :west
      get_next_tuple(x, y, :south)
    when :east
      get_next_tuple(x, y, :north)
    else
      raise "Invalid direction"
    end
  end

  def handle_forward_slash(x, y, direction)
    case direction
    when :north
      get_next_tuple(x, y, :west)
    when :south
      get_next_tuple(x, y, :east)
    when :west
      get_next_tuple(x, y, :north)
    when :east
      get_next_tuple(x, y, :south)
    else
      raise "Invalid direction"
    end
  end

  def get_next_tuple(x, y, direction)
    case direction
    when :north
      {x, y - 1, direction}
    when :south
      {x, y + 1, direction}
    when :west
      {x - 1, y, direction}
    when :east
      {x + 1, y, direction}
    else
      raise "Invalid direction"
    end
  end

  def parse_input(input)
    input.split('\n').map do |str|
      str.chars
    end
  end
end

stop_if_not_script(__FILE__)
# test_run(".|...\\....
# |.-.\\.....
# .....|-...
# ........|.
# ..........
# .........\\
# ..../.\\\\..
# .-.-/..|..
# .|....-|.\\
# ..//.|....")
run(__FILE__)
