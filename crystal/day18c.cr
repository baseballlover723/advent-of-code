require "./base"

# https://www.reddit.com/r/adventofcode/comments/18l0qtr/2023_day_18_solutions/kduuicl/
class Day18c < Base
  def solve(arg)
    directions = parse_input(arg)
    # puts "directions: #{directions}"

    x = 0
    y = 0
    total = 0
    area = 0
    directions.each do |(direction, count)|
      total += count
      case direction
      when 'U'
        y -= count
        area += x * -count
      when 'L'
        x -= count
      when 'D'
        y += count
        area += x * count
      when 'R'
        x += count
      end
    end
    area + total // 2 + 1
  end

  def parse_input(input)
    input.split('\n').map do |str|
      split = str.split(' ')
      {split[0][0], split[1].to_i}
    end
  end
end

stop_if_not_script(__FILE__)
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
