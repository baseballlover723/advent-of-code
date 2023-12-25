require "./base"

def solve(arg)
  directions = parse_input(arg)
  # puts "directions: #{directions}"

  x = 0
  y = 0
  total = 0
  points = directions.map do |direction, count|
    total += count
    case direction
    when '3'
      y -= count
    when '2'
      x -= count
    when '1'
      y += count
    when '0'
      x += count
    end
    [x, y]
  end
  points << points[0]
  # puts "points: #{points}"

  calc_area(points) + total / 2 + 1
end

def calc_area(points)
  area = 0
  points.each_cons(2) do |(x1, y1), (x2, y2)|
    area += (y1 + y2) * (x1 - x2)
  end
  area / 2
end

def parse_input(input)
  input.split("\n").map do |str|
    _, hex = str.split('#')

    [hex[-2], hex[0..-3].to_i(16)]
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
run(__FILE__)
