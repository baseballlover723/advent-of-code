require_relative "../../base"

def solve(arg)
  maze, x, y = parse_input(arg)
  # puts "maze: "
  # maze.each do |row|
  #   puts row.map {|b| b ? '.' : '#'}.join
  # end
  # puts "start: (#{x}, #{y})"

  max_y = maze.size
  max_x = maze[0].size

  locations = Set.new
  locations << [x,y]
  # 6.times do |i|
  64.times do |i|
    locations = iterate(maze, locations, max_x, max_y)
  end

  # puts "locations: #{locations}"
  locations.size
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
    xx >= 0 && xx < max_x && yy >= 0 && yy < max_y && maze[yy][xx]
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
