require "../../base"

class Year2023::Day10a < Base
  def solve(arg)
    maze = parse_input(arg)
    # maze.each do |row|
    #   puts row.inspect
    # end
    x, y = find_start(maze)
    # puts "start: (#{x}, #{y})"

    max_y = maze.size - 1
    max_x = maze[0].size - 1
    locations = [] of Tuple(Int32, Int32, Symbol)
    locations << {x - 1, y, :west} if x - 1 >= 0 && ['-', 'L', 'F'].includes?(maze[y][x - 1])
    locations << {x + 1, y, :east} if x + 1 <= max_x && ['-', 'J', '7'].includes?(maze[y][x + 1])
    locations << {x, y - 1, :north} if y - 1 >= 0 && ['|', '7', 'F'].includes?(maze[y - 1][x])
    locations << {x, y + 1, :south} if y + 1 <= max_y && ['|', 'L', 'J'].includes?(maze[y + 1][x])
    # puts "locations: #{locations}"

    # seen = Set.new
    # seen << [x, y]
    steps = 1
    loop do
      return steps if locations[0][0] == locations[1][0] && locations[0][1] == locations[1][1]
      locations.map! do |(x, y, direction)|
        # puts "steps: #{steps}, (#{x}, #{y}): #{maze[y][x]} -> #{direction}"
        # return steps if !seen.add?([x, y])
        case maze[y][x]
        when '|'
          direction == :north ? {x, y - 1, :north} : {x, y + 1, :south}
        when '-'
          direction == :east ? {x + 1, y, :east} : {x - 1, y, :west}
        when 'L'
          direction == :south ? {x + 1, y, :east} : {x, y - 1, :north}
        when 'J'
          direction == :south ? {x - 1, y, :west} : {x, y - 1, :north}
        when '7'
          direction == :north ? {x - 1, y, :west} : {x, y + 1, :south}
        when 'F'
          direction == :north ? {x + 1, y, :east} : {x, y + 1, :south}
        else
          raise "Invalid char (#{maze[y][x]})"
        end
      end
      steps += 1
    end
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
# test_run("..F7.
# .FJ|.
# SJ.L7
# |F--J
# LJ...")
run(__FILE__)
