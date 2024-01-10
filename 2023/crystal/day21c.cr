require "../../base"

class Year2023::Day21c < Base
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

    locations = Set(Tuple(Int16, Int16)).new
    locations << {x, y}
    last_locations = Set(Tuple(Int16, Int16)).new
    two_ago = last_locations.size.to_i64
    one_ago = locations.size.to_i64

    i = 0
    offset = steps % max_x
    modified_steps = (steps - offset) // max_x

    offset.times do |_|
      i += 1
      last_locations, locations = iterate(maze, locations, last_locations, max_x, max_y)

      one_ago, two_ago = two_ago + locations.size, one_ago
      # puts "#{i}: one_ago: #{one_ago}, two_ago: #{two_ago}, locations: #{locations.size}, last_locations: #{last_locations.size}"
    end
    locations_count = StaticArray(Int64, 3).new(0_i64)
    locations_count[0] = one_ago

    2.times do |ai|
      max_x.times do |_|
        i += 1
        last_locations, locations = iterate(maze, locations, last_locations, max_x, max_y)

        one_ago, two_ago = two_ago + locations.size, one_ago
        # puts "#{i}: one_ago: #{one_ago}, two_ago: #{two_ago}, locations: #{locations.size}, last_locations: #{last_locations.size}"
        # puts "#{i}: #{locations.size}"
      end
      locations_count[ai + 1] = one_ago
    end

    # puts "locations_count: #{locations_count}"
    # puts "steps: #{steps}, offset: #{offset}, modified_steps: #{modified_steps}"

    # (0..modified_steps).each do |ii|
    #   puts "calced parabola @ #{ii}: #{calc_parabola(ii, [2,3,4], locations_count[2..4])}"
    # end

    calc_parabola(modified_steps, {0_i64, 1_i64, 2_i64}, locations_count)
  end

  def calc_parabola(x : Int32, xs : Tuple(Int64, Int64, Int64), ys : StaticArray(Int64, 3))
    x1, x2, x3 = xs
    y1, y2, y3 = ys
    p1 = y1 * (x - x2) * (x - x3) // ((x1 - x2) * (x1 - x3))
    p2 = y2 * (x - x1) * (x - x3) // ((x2 - x1) * (x2 - x3))
    p3 = y3 * (x - x1) * (x - x2) // ((x3 - x1) * (x3 - x2))
    p1 + p2 + p3
  end

  def iterate(maze, locations, last_locations, max_x, max_y)
    new_locations = Set(Tuple(Int16, Int16)).new
    locations.each do |x, y|
      calc_valid_next_locations(maze, last_locations, x, y, max_x, max_y).each do |location|
        # puts "location: #{location}"
        new_locations << location
      end
    end
    {locations, new_locations}
  end

  def calc_valid_next_locations(maze, last_locations, x, y, max_x, max_y)
    calc_possible_next_locations(x, y).select do |xx, yy|
      maze[yy % max_y][xx % max_x] && !last_locations.includes?({xx, yy})
    end
  end

  def calc_possible_next_locations(x, y)
    { {x, y &- 1_i16}, {x &- 1_i16, y}, {x, y &+ 1_i16}, {x &+ 1_i16, y} }
  end

  def parse_input(input)
    x = 0_i16
    y = 0_i16
    maze = input.split('\n').map_with_index do |str, yy|
      str.each_char.map_with_index do |c, xx|
        if c == 'S'
          x = xx.to_i16
          y = yy.to_i16
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
