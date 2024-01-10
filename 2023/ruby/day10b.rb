require_relative "../../base"

def solve(arg)
  maze = parse_input(arg)
  # maze.each do |row|
  #   puts row.inspect
  # end
  x, y = find_start(maze)
  # puts "start: (#{x}, #{y})"

  max_y = maze.size - 1
  max_x = maze[0].size - 1
  locations = []
  locations << [x - 1, y, :west] if x - 1 >= 0 && %w[- L F].include?(maze[y][x - 1])
  locations << [x + 1, y, :east] if x + 1 <= max_x && %w[- J 7].include?(maze[y][x + 1])
  locations << [x, y - 1, :north] if y - 1 >= 0 && %w[| 7 F].include?(maze[y - 1][x])
  locations << [x, y + 1, :south] if y + 1 <= max_y && %w[| L J].include?(maze[y + 1][x])

  start_char = calc_start_char(locations)
  # puts "start_char: #{start_char}"
  maze[y][x] = start_char
  # puts "locations: #{locations}"

  xs = x
  xe = x
  ys = y
  ye = y
  seen = Set.new
  seen << [x, y]
  loop do
    if locations[0][0] == locations[1][0] && locations[0][1] == locations[1][1]
      xs = locations[0][0] if locations[0][0] < xs
      xe = locations[0][0] if locations[0][0] > xe
      ys = locations[0][1] if locations[0][1] < ys
      ye = locations[0][1] if locations[0][1] > ye
      seen << [locations[0][0], locations[0][1]]
      break
    end
    locations.map! do |(x, y, direction)|
      # puts "steps: #{steps}, (#{x}, #{y}): #{maze[y][x]} -> #{direction}"
      xs = x if x < xs
      xe = x if x > xe
      ys = y if y < ys
      ye = y if y > ye
      seen << [x,y]
      case maze[y][x]
      when '|'
        direction == :north ? [x, y - 1, :north] : [x, y + 1, :south]
      when '-'
        direction == :east ? [x + 1, y, :east] : [x - 1, y, :west]
      when 'L'
        direction == :south ? [x + 1, y, :east] : [x, y - 1, :north]
      when 'J'
        direction == :south ? [x - 1, y, :west] : [x, y - 1, :north]
      when '7'
        direction == :north ? [x - 1, y, :west] : [x, y + 1, :south]
      when 'F'
        direction == :north ? [x + 1, y, :east] : [x, y + 1, :south]
      end
    end
  end
  # puts "seen: #{seen}"

  area = 0
  y = ys
  while y <= ye
    interior = false
    x = xs
    while x <= xe
      # puts "(#{x}, #{y}): #{maze[y][x]}"
      if !seen.include?([x, y])
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

def calc_start_char(locations)
  case [locations[0][2], locations[1][2]]
  when [:west, :east]
    '-'
  when [:west, :north]
    'J'
  when [:west, :south]
    '7'
  when [:east, :north]
    'L'
  when [:east, :south]
    'F'
  when [:north, :south]
    '|'
  end
end

def find_start(maze)
  maze.each_with_index do |row, y|
    row.each_with_index do |c, x|
      return [x, y] if c == 'S'
    end
  end
end

def parse_input(input)
  input.split("\n").map { |str| str.chars }
end

return if __FILE__ != $0
# test_run("...........
# .S-------7.
# .|F-----7|.
# .||.....||.
# .||.....||.
# .|L-7.F-J|.
# .|..|.|..|.
# .L--J.L--J.
# ...........")
# test_run("..........
# .S------7.
# .|F----7|.
# .||OOOO||.
# .||OOOO||.
# .|L-7F-J|.
# .|II||II|.
# .L--JL--J.
# ..........")
# test_run(".F----7F7F7F7F-7....
# .|F--7||||||||FJ....
# .||.FJ||||||||L7....
# FJL7L7LJLJ||LJ.L-7..
# L--J.L7...LJS7F-7L7.
# ....F-J..F7FJ|L7L7L7
# ....L7.F7||L7|.L7L7|
# .....|FJLJ|FJ|F7|.LJ
# ....FJL-7.||.||||...
# ....L---J.LJ.LJLJ...")
# test_run("FF7FSF7F7F7F7F7F---7
# L|LJ||||||||||||F--J
# FL-7LJLJ||||||LJL-77
# F--JF--7||LJLJ7F7FJ-
# L---JF-JLJ.||-FJLJJ7
# |F|F-JF---7F7-L7L|7|
# |FFJF7L7F-JF7|JL---7
# 7-L-JL7||F7|L7F-7F7|
# L.L7LFJ|||||FJL7||LJ
# L7JLJL-JLJLJL--JLJ.L")
run(__FILE__)
