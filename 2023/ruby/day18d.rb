require_relative "../../base"

def solve(arg)
  directions = parse_input(arg)
  # puts "directions: #{directions}"

  maze, start_x, start_y = calc_size(directions)
  # max_y = maze.size
  # max_x = maze[0].size
  # puts "start: (#{start_x}, #{start_y})"
  # puts "max: (#{max_x}, #{max_y})"
  # puts "maze:"
  # maze.each do |row|
  #   puts row.join
  # end

  calc_area(maze, start_x, start_y, directions)
end

def calc_area(maze, start_x, start_y, directions)
  max_y = maze.size
  max_x = maze[0].size
  x = start_x
  y = start_y

  seen = Array.new(max_y) { Array.new(max_x, false)}

  area = 0
  directions.each do |direction, count|
    case direction
    when :north
      count.times do |_|
        y -= 1
        seen[y][x] = true
        area += 1
      end
    when :west
      count.times do |_|
        x -= 1
        seen[y][x] = true
        area += 1
      end
    when :south
      count.times do |_|
        y += 1
        seen[y][x] = true
        area += 1
      end
    when :east
      count.times do |_|
        x += 1
        seen[y][x] = true
        area += 1
      end
    end
  end

  y = 1
  max_y -= 1
  max_x -= 1
  while y < max_y
    interior = seen[y][0]
    x = 1
    while x < max_x
      # puts "(#{x}, #{y}): #{maze[y][x]}"
      if !seen[y][x]
        # puts "(#{x}, #{y}): #{interior}" if interior
        area += 1 if interior
        x += 1
        next
      end
      if maze[y][x] == '|'
        interior = !interior
        # puts "flipping (#{x}, #{y}): #{interior}"
      elsif maze[y][x] == 'F'
        x += 1
        while maze[y][x] == '-'
          x += 1
        end
        if maze[y][x] == 'J'
          interior = !interior
          # puts "flipping (#{x}, #{y}): #{interior}"
        end
      elsif maze[y][x] == 'L'
        x += 1
        while maze[y][x] == '-'
          x += 1
        end
        if maze[y][x] == '7'
          interior = !interior
          # puts "flipping (#{x}, #{y}): #{interior}"
        end
      end
      x += 1
    end
    y += 1
  end

  area
end

def calc_size(directions)
  min_x = 0
  min_y = 0
  max_x = 0
  max_y = 0

  x = 0
  y = 0
  directions.each do |direction, count|
    # puts "(#{x}, #{y})"
    case direction
    when :north
      y -= count
      min_y = y if y < min_y
    when :west
      x -= count
      min_x = x if x < min_x
    when :south
      y += count
      max_y = y if y > max_y
    when :east
      x += count
      max_x = x if x > max_x
    end
  end

  start_x = min_x * -1
  start_y = min_y * -1
  x = start_x
  y = start_y

  maze = Array.new(max_y - min_y + 1) { Array.new(max_x - min_x + 1, '.') }

  last_direction = directions[-1][0]
  directions.each do |direction, count|
    maze[y][x] = calc_corner(last_direction, direction)
    case direction
    when :north
      ((y - count + 1)...(y)).each do |yy|
        maze[yy][x] = '|'
      end
      y -= count
      min_y = y if y < min_y
    when :west
      ((x - count + 1)...(x)).each do |xx|
        maze[y][xx] = '-'
      end
      x -= count
      min_x = x if x < min_x
    when :south
      ((y + 1)...(y + count)).each do |yy|
        maze[yy][x] = '|'
      end
      y += count
      max_y = y if y > max_y
    when :east
      ((x + 1)...(x + count)).each do |xx|
        maze[y][xx] = '-'
      end
      x += count
      max_x = x if x > max_x
    end
    last_direction = direction
  end

  [maze, start_x, start_y]
end

def calc_corner(last_direction, direction)
  case [last_direction, direction]
  when [:north, :east], [:west, :south]
    'F'
  when [:north, :west], [:east, :south]
    '7'
  when [:west, :north], [:south, :east]
    'L'
  when [:south, :west], [:east, :north]
    'J'
  end
end

def convert_dir(dir)
  case dir
  when 'U'
    :north
  when 'L'
    :west
  when 'D'
    :south
  when 'R'
    :east
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    split = str.split(' ')
    [convert_dir(split[0]), split[1].to_i]
  end
end

return if __FILE__ != $0
# test_run("R 6 (#70c710)
# D 5 (#0dc571)
# L 2 (#5713f0)
# D 2 (#d2c081)
# R 2 (#59c680)
# D 2 (#411b91)
# L 5 (#8ceee2)
# U 2 (#caa173)
# L 1 (#1b58a2)
# U 2 (#caa171)
# R 2 (#7807d2)
# U 3 (#a77fa3)
# L 2 (#015232)
# U 2 (#7a21e3)")

# test_run("L 6 (#70c710)
# D 6 (#0dc571)
# R 6 (#5713f0)
# U 6 (#d2c081)")

# test_run("R 1 (#70c710)
# D 1 (#70c710)
# R 3 (#70c710)
# U 1 (#70c710)
# R 1 (#70c710)
# D 5 (#0dc571)
# L 5 (#5713f0)
# U 5 (#d2c081)")
# test_run("R 3 (#70c710)
# U 1 (#70c710)
# R 1 (#70c710)
# D 5 (#0dc571)
# L 5 (#5713f0)
# U 5 (#d2c081)
# R 1 (#70c710)
# D 1 (#70c710)")

run(__FILE__)
