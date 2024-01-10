require "../../base"

class Year2023::Day21a < Base
  def solve(arg)
    maze, x, y = parse_input(arg)
    # puts "maze: "
    # maze.each do |row|
    #   puts row.map {|b| b ? '.' : '#'}.join
    # end
    # puts "start: (#{x}, #{y})"

    max_y = maze.size.to_u8
    max_x = maze[0].size.to_u8

    locations = Set(Tuple(UInt8, UInt8)).new
    locations << {x, y}
    # 6.times do |i|
    64.times do |i|
      locations = iterate(maze, locations, max_x, max_y)
    end

    # puts "locations: #{locations}"
    locations.size
  end

  def iterate(maze, locations, max_x, max_y)
    new_set = Set(Tuple(UInt8, UInt8)).new
    locations.each do |x, y|
      calc_valid_next_locations(maze, x, y, max_x, max_y).each do |location|
        new_set << location
      end
    end
    new_set
  end

  def calc_valid_next_locations(maze, x, y, max_x, max_y)
    calc_possible_next_locations(x, y).select do |xx, yy|
      xx < max_x && yy < max_y && maze[yy][xx]
    end
  end

  def calc_possible_next_locations(x, y)
    { {x, y &- 1_u8}, {x &- 1_u8, y}, {x, y &+ 1_u8}, {x &+ 1_u8, y} }
  end

  def parse_input(input)
    x = 0_u8
    y = 0_u8
    maze = input.split('\n').map_with_index do |str, yy|
      str.each_char.map_with_index do |c, xx|
        if c == 'S'
          x = xx.to_u8
          y = yy.to_u8
        end
        c != '#'
      end
    end
    {maze, x, y}
  end
end

stop_if_not_script(__FILE__)
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
