require "./base"

class Day21d < Base
  def solve(arg)
    max_x = parse_input(arg)

    calc_steps_at(max_x, 26501365)
  end

  def calc_steps_at(max_x, steps)
    offset = steps % max_x
    modified_steps = (steps - offset) // max_x

    locations_count = {3759_i64, 33496_i64, 92857_i64}
    calc_parabola(modified_steps, {0_i64, 1_i64, 2_i64}, locations_count)
  end

  def calc_parabola(x : Int32, xs : Tuple(Int64, Int64, Int64), ys : Tuple(Int64, Int64, Int64))
    x1, x2, x3 = xs
    y1, y2, y3 = ys
    p1 = y1 * (x - x2) * (x - x3) // ((x1 - x2) * (x1 - x3))
    p2 = y2 * (x - x1) * (x - x3) // ((x2 - x1) * (x2 - x3))
    p3 = y3 * (x - x1) * (x - x2) // ((x3 - x1) * (x3 - x2))
    p1 + p2 + p3
  end

  def parse_input(input)
    input.index('\n').not_nil!
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
