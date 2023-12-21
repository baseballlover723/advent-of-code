require "./base"

DIRECTIONS = {north: 0, west: 1, south: 2, east: 3} unless defined? DIRECTIONS

# with removing other entrances spotted
# with separate logic when it goes off the edge for seen entrances
# without set and using array of bools (of directions) for direction checking
def solve(arg)
  matrix = parse_input(arg)
  # puts "matrix: "
  # matrix.each do |row|
  #   puts row.join
  # end

  max_y = matrix.size
  max_x = matrix[0].size

  # $matrix_count = 0
  # $steps = 0
  max = 0
  seen_starts = Set.new
  [[-1, 0...max_y], [0...max_x, -1], [max_x, 0...max_y] ,[0...max_x, max_y]].flat_map do |x, y|
    calc_starts(x, y)
  end.each do |start|
    next if seen_starts.include?([start[0], start[1]])
    # puts "start: #{start}"
    count, other_seen_starts = simulate_beams(matrix, max_y, max_x, start)
    max = count if count > max
    # puts "other_seen_starts: #{other_seen_starts.to_a.sort}"
    seen_starts.merge(other_seen_starts)
    # break
  end

  # puts "matrix_count: #{$matrix_count}"
  # puts "steps: #{$steps}"

  max
end

def calc_starts(x, y)
  x.is_a?(Range) ? calc_starts1(x, y) : calc_starts2(x, y)
end

def calc_starts1(x_range, y)
  dir = y == -1 ? :south : :north
  x_range.map do |x|
    [x, y, dir]
  end
end

def calc_starts2(x, y_range)
  dir = x == -1 ? :east : :west
  y_range.map do |y|
    [x, y, dir]
  end
end

def simulate_beams(matrix, max_y, max_x, start)
  bools = Array.new(max_y) { Array.new(max_x) { [false, false, false, false]} }
  queue = [get_next_tuple(*start)]
  other_seen_starts = Set.new
  other_seen_starts << [start[0], start[1]]
  # $matrix_count += 1

  while !queue.empty?
    x, y, direction = queue.shift
    # puts "(#{x}, #{y}), #{direction}"
    if x < 0 || x >= max_x || y < 0 || y >= max_y
      other_seen_starts << [x, y]
      next
    end
    next if bools[y][x][DIRECTIONS[direction]]
    # $steps += 1
    # puts "(#{x}, #{y}), #{direction}: matrix: #{matrix[y][x]}"
    bools[y][x][DIRECTIONS[direction]] = true
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
    row.sum {|b| b.any? ? 1 : 0 }
  end

  # other_seen_starts = seen.filter do |x, y, direction|
  #   x == -1 || x == max_x || y == -1 || y == max_y
  # end.map do |x, y, direction|
  #   [x,y]
  # end

  # puts "other_seen_starts: #{other_seen_starts}"

  [energized, other_seen_starts]
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
  end
end

def get_next_tuple(x, y, direction)
  case direction
  when :north
    [x, y - 1, direction]
  when :south
    [x, y + 1, direction]
  when :west
    [x - 1, y, direction]
  when :east
    [x + 1, y, direction]
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    str.chars
  end
end

return if __FILE__ != $0
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
