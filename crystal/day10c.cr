require "./base"

# using Shoelace Theorem from day 18
class Day10c < Base
  def solve(arg)
    maze = parse_input(arg)
    # maze.each do |row|
    #   puts row.inspect
    # end
    start_x, start_y = find_start(maze)
    # puts "start: (#{start_x}, #{start_y})"

    max_y = maze.size - 1
    max_x = maze[0].size - 1
    locations = [] of Tuple(Int32, Int32, Symbol)
    locations << {start_x - 1, start_y, :west} if start_x - 1 >= 0 && ['-', 'L', 'F'].includes?(maze[start_y][start_x - 1])
    locations << {start_x + 1, start_y, :east} if start_x + 1 <= max_x && ['-', 'J', '7'].includes?(maze[start_y][start_x + 1])
    locations << {start_x, start_y - 1, :north} if start_y - 1 >= 0 && ['|', '7', 'F'].includes?(maze[start_y - 1][start_x])

    x, y, direction = locations[0]
    points = [{start_x, start_y}]
    perimeter = 0
    while x != start_x || y != start_y
      # puts "steps: #{steps}, (#{x}, #{y}): #{maze[y][x]} -> #{direction}"
      perimeter += 1
      x, y, direction = case maze[y][x]
                        when '|'
                          direction == :north ? {x, y - 1, :north} : {x, y + 1, :south}
                        when '-'
                          direction == :east ? {x + 1, y, :east} : {x - 1, y, :west}
                        when 'L'
                          points << {x, y}
                          direction == :south ? {x + 1, y, :east} : {x, y - 1, :north}
                        when 'J'
                          points << {x, y}
                          direction == :south ? {x - 1, y, :west} : {x, y - 1, :north}
                        when '7'
                          points << {x, y}
                          direction == :north ? {x - 1, y, :west} : {x, y + 1, :south}
                        when 'F'
                          points << {x, y}
                          direction == :north ? {x + 1, y, :east} : {x, y + 1, :south}
                        else
                          raise "Invalid char (#{maze[y][x]})"
                        end
    end
    # puts "seen: #{seen}"
    # puts "points: #{points}"
    points << points[0]
    calc_area(points).abs - perimeter // 2
  end

  def calc_area(points)
    area = 0
    points.each_cons(2) do |((x1, y1), (x2, y2))|
      area += (y1 + y2) * (x1 - x2)
    end
    area // 2
  end

  def find_start(maze)
    maze.each_with_index do |row, y|
      row.each_with_index do |c, x|
        return {x, y} if c == 'S'
      end
    end
    raise "Couldn't find start"
  end

  def parse_input(input)
    input.split('\n').map { |str| str.chars }
  end
end

stop_if_not_script(__FILE__)
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
