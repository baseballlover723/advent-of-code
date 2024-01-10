require_relative "../../base"

def solve(arg)
  max_x = parse_input(arg)

  calc_steps_at(max_x, 26501365)
end

def calc_steps_at(max_x, steps)
  offset = steps % max_x
  modified_steps = (steps - offset) / max_x

  locations_count = [3759, 33496, 92857]
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

def parse_input(input)
  input.index("\n")
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
