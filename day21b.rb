require "./base"

def solve(arg)
  maze, x, y = parse_input(arg)
  # puts "maze: "
  # maze.each do |row|
  #   puts row.map {|b| b ? '.' : '#'}.join
  # end
  # puts "start: (#{x}, #{y})"

  calc_steps_at(maze, x, y, 26501365)
end

def calc_steps_at(maze, x, y, steps)
  max_y = maze.size
  max_x = maze[0].size

  locations = Set.new
  locations << [x,y]

  i = 0
  offset = steps % max_x
  modified_steps = (steps - offset) / max_x

  offset.times do |_|
    i += 1
    locations = iterate(maze, locations, max_x, max_y)
    # puts "#{i}: #{locations.size}"
  end
  locations_count = [locations.size]

  2.times do |_|
    max_x.times do |_|
      i += 1
      locations = iterate(maze, locations, max_x, max_y)
      # puts "#{i}: #{locations.size}"
    end
    locations_count << locations.size
  end

  # puts "locations_count: #{locations_count}"
  # puts "steps: #{steps}, offset: #{offset}, modified_steps: #{modified_steps}"

  # (0..modified_steps).each do |ii|
  #   puts "calced parabola @ #{ii}: #{calc_parabola(ii, [2,3,4], locations_count[2..4])}"
  # end

  calc_parabola(modified_steps, [0,1,2], locations_count)
end

def calc_parabola(x, xs, ys)
  x1,x2,x3 = xs
  y1,y2,y3 = ys
  p1 = y1 * (x - x2) * (x - x3) / ((x1 - x2) * (x1 - x3))
  p2 = y2 * (x - x1) * (x - x3) / ((x2 - x1) * (x2 - x3))
  p3 = y3 * (x - x1) * (x - x2) / ((x3 - x1) * (x3 - x2))
  p1 + p2 + p3
end

def iterate(maze, locations, max_x, max_y)
  new_set = Set.new
  locations.each do |x, y|
    calc_valid_next_locations(maze, x, y, max_x, max_y).each do |location|
      new_set << location
    end
  end
  new_set
end

def calc_valid_next_locations(maze, x, y, max_x, max_y)
  calc_possible_next_locations(x, y).select do |xx,yy|
    maze[yy % max_y][xx % max_x]
  end
end

def calc_possible_next_locations(x, y)
  [[x, y-1], [x-1, y], [x,y+1], [x+1, y]]
end

def parse_input(input)
  x = 0
  y = 0
  maze = input.split("\n").map.with_index do |str, yy|
    str.each_char.map.with_index do |c, xx|
      if c == 'S'
        x = xx
        y = yy
      end
      c != '#'
    end
  end
  [maze, x, y]
end

return if __FILE__ != $0
# test_run("...........
# .....###.#.
# .###.##..#.
# ..#.#...#..
# ....#.#....
# .##..S####.
# .##..#...#.
# .......##..
# .##.#.####.
# .##..##.##.
# ...........")
run(__FILE__)
