require "../../base"

class Year2023::Day24a < Base
  def solve(arg)
    hail = parse_input(arg)
    # puts "hail: #{hail[0]}"
    # x_range = 7..27
    # y_range = 7..27

    x_range = 200_000_000_000_000_u64..400_000_000_000_000_u64
    y_range = 200_000_000_000_000_u64..400_000_000_000_000_u64

    sum = 0
    hail.map do |h|
      calc_formula(h, x_range, y_range)
    end.compact.each_combination(2) do |(h1, h2)|
      sum += 1 if hail_intersect?(x_range, y_range, h1, h2)
    end
    sum
  end

  def calc_formula(h, x_range, y_range) : Tuple(UInt64, UInt64, UInt64, Int16, Int16, Int16, Float64, Float64)?
    px, py, _, dx, dy, _ = h
    a = dy / dx.to_f
    b = py - a * px

    # puts "a: #{a}, b: #{b}"
    return nil if (dx == 0 && !x_range.includes?(px)) || (dx > 0 && px > x_range.end) || (dx < 0 && px < x_range.begin) || (dy == 0 && !y_range.includes?(py)) || (dy > 0 && py > y_range.end) || (dy < 0 && py < y_range.begin)
    return nil if ((a * x_range.begin + b < y_range.begin) && (a * x_range.end + b < y_range.begin)) || ((a * x_range.begin + b > y_range.end) && (a * x_range.end + b > y_range.end))
    {*h, a, b}
  end

  def hail_intersect?(x_range, y_range, h1, h2)
    # puts "h1: #{h1}, h2: #{h2}"
    px1, py1, _, dx1, dy1, _, a1, b1 = h1
    px2, py2, _, dx2, dy2, _, a2, b2 = h2
    return b1 == b2 if a1 == a2

    x = (b2 - b1) / (a1 - a2)
    y = a1 * x + b1
    # puts "x: #{x}, y: #{y}"

    return false if !x_range.includes?(x) || !y_range.includes?(y)

    ((dx1 <=> 0) == (x <=> px1)) && ((dy1 <=> 0) == (y <=> py1)) && ((dx2 <=> 0) == (x <=> px2)) && ((dy2 <=> 0) == (y <=> py2))
  end

  def parse_input(input)
    input.split('\n').map do |str|
      pos, vel = str.split(" @ ")
      {*Tuple(String, String, String).from(pos.split(", ")).map(&.to_u64), *Tuple(String, String, String).from(vel.split(", ")).map(&.to_i16)}
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("19, 13, 30 @ -2,  1, -2
# 18, 19, 22 @ -1, -1, -2
# 20, 25, 34 @ -2, -2, -4
# 12, 31, 28 @ -1, -2, -1
# 20, 19, 15 @  1, -5, -3")
# test_run("0, 0, 30 @ 2,  1, -2
# 0, 0, 30 @ 1,  2, -2
# 0, 30, 22 @ 1, -1, -2
# 0, 35, 22 @ 2, -1, -2
# 20, 25, 34 @ -2, -2, -4
# 12, 31, 28 @ -1, -2, -1
# 20, 19, 15 @  1, -5, -3")
# test_run("7, 7, 1 @ 1, 1, 1
# 7, 17, 1 @ 1, 1, 1
# 7, 27, 1 @ 1, 1, 1
# 17, 7, 1 @ 1, 1, 1
# 17, 17, 1 @ 1, 1, 1
# 17, 27, 1 @ 1, 1, 1
# 27, 7, 1 @ 1, 1, 1
# 27, 17, 1 @ 1, 1, 1
# 27, 27, 1 @ 1, 1, 1
# 7, 7, 1 @ -1, 1, 1
# 7, 17, 1 @ -1, 1, 1
# 7, 27, 1 @ -1, 1, 1
# 17, 7, 1 @ -1, 1, 1
# 17, 17, 1 @ -1, 1, 1
# 17, 27, 1 @ -1, 1, 1
# 27, 7, 1 @ -1, 1, 1
# 27, 17, 1 @ -1, 1, 1
# 27, 27, 1 @ -1, 1, 1
# 7, 7, 1 @ 1, -1, 1
# 7, 17, 1 @ 1, -1, 1
# 7, 27, 1 @ 1, -1, 1
# 17, 7, 1 @ 1, -1, 1
# 17, 17, 1 @ 1, -1, 1
# 17, 27, 1 @ 1, -1, 1
# 27, 7, 1 @ 1, -1, 1
# 27, 17, 1 @ 1, -1, 1
# 27, 27, 1 @ 1, -1, 1
# 7, 7, 1 @ -1, -1, 1
# 7, 17, 1 @ -1, -1, 1
# 7, 27, 1 @ -1, -1, 1
# 17, 7, 1 @ -1, -1, 1
# 17, 17, 1 @ -1, -1, 1
# 17, 27, 1 @ -1, -1, 1
# 27, 7, 1 @ -1, -1, 1
# 27, 17, 1 @ -1, -1, 1
# 27, 27, 1 @ -1, -1, 1
# 5, 5, 1 @ 1, 1, 1
# 5, 7, 1 @ 1, 1, 1
# 5, 17, 1 @ 1, 1, 1
# 5, 27, 0 @ 1, 1, 0
# 5, 35, 0 @ 1, 1, 0
# 7, 5, 1 @ 1, 1, 1
# 7, 35, 0 @ 1, 1, 0
# 17, 5, 1 @ 1, 1, 1
# 17, 35, 0 @ 1, 1, 0
# 27, 5, 0 @ 1, 1, 0
# 27, 35, 0 @ 1, 1, 0
# 35, 5, 0 @ 1, 1, 0
# 35, 7, 0 @ 1, 1, 0
# 35, 17, 0 @ 1, 1, 0
# 35, 27, 0 @ 1, 1, 0
# 35, 35, 0 @ 1, 1, 0
# 5, 5, 0 @ -1, 1, 0
# 5, 7, 0 @ -1, 1, 0
# 5, 17, 0 @ -1, 1, 0
# 5, 27, 0 @ -1, 1, 0
# 5, 35, 0 @ -1, 1, 0
# 7, 5, 0 @ -1, 1, 0
# 7, 35, 0 @ -1, 1, 0
# 17, 5, 1 @ -1, 1, 1
# 17, 35, 0 @ -1, 1, 0
# 27, 5, 1 @ -1, 1, 1
# 27, 35, 0 @ -1, 1, 0
# 35, 5, 1 @ -1, 1, 1
# 35, 7, 1 @ -1, 1, 1
# 35, 17, 1 @ -1, 1, 1
# 35, 27, 0 @ -1, 1, 0
# 35, 35, 0 @ -1, 1, 0
# 5, 5, 0 @ 1, -1, 0
# 5, 7, 0 @ 1, -1, 0
# 5, 17, 1 @ 1, -1, 1
# 5, 27, 1 @ 1, -1, 1
# 5, 35, 1 @ 1, -1, 1
# 7, 5, 0 @ 1, -1, 0
# 7, 35, 1 @ 1, -1, 1
# 17, 5, 0 @ 1, -1, 0
# 17, 35, 1 @ 1, -1, 1
# 27, 5, 0 @ 1, -1, 0
# 27, 35, 0 @ 1, -1, 0
# 35, 5, 0 @ 1, -1, 0
# 35, 7, 0 @ 1, -1, 0
# 35, 17, 0 @ 1, -1, 0
# 35, 27, 0 @ 1, -1, 0
# 35, 35, 0 @ 1, -1, 0
# 5, 5, 0 @ -1, -1, 0
# 5, 7, 0 @ -1, -1, 0
# 5, 17, 0 @ -1, -1, 0
# 5, 27, 0 @ -1, -1, 0
# 5, 35, 0 @ -1, -1, 0
# 7, 5, 0 @ -1, -1, 0
# 7, 35, 0 @ -1, -1, 0
# 17, 5, 0 @ -1, -1, 0
# 17, 35, 1 @ -1, -1, 1
# 27, 5, 0 @ -1, -1, 0
# 27, 35, 1 @ -1, -1, 1
# 35, 5, 0 @ -1, -1, 0
# 35, 7, 0 @ -1, -1, 0
# 35, 17, 1 @ -1, -1, 1
# 35, 27, 1 @ -1, -1, 1
# 35, 35, 1 @ -1, -1, 1
# 5, 5, 0 @ 0, 1, 0
# 5, 7, 0 @ 0, 1, 0
# 5, 17, 0 @ 0, 1, 0
# 5, 27, 0 @ 0, 1, 0
# 5, 35, 0 @ 0, 1, 0
# 7, 5, 1 @ 0, 1, 1
# 7, 7, 1 @ 0, 1, 1
# 7, 17, 1 @ 0, 1, 1
# 7, 27, 1 @ 0, 1, 1
# 7, 35, 0 @ 0, 1, 0
# 17, 5, 1 @ 0, 1, 1
# 17, 7, 1 @ 0, 1, 1
# 17, 17, 1 @ 0, 1, 1
# 17, 27, 1 @ 0, 1, 1
# 17, 35, 0 @ 0, 1, 0
# 27, 5, 1 @ 0, 1, 1
# 27, 7, 1 @ 0, 1, 1
# 27, 17, 1 @ 0, 1, 1
# 27, 27, 1 @ 0, 1, 1
# 27, 35, 0 @ 0, 1, 0
# 35, 5, 0 @ 0, 1, 0
# 35, 7, 0 @ 0, 1, 0
# 35, 17, 0 @ 0, 1, 0
# 35, 27, 0 @ 0, 1, 0
# 35, 35, 0 @ 0, 1, 0
# 5, 5, 0 @ 0, -1, 0
# 5, 7, 0 @ 0, -1, 0
# 5, 17, 0 @ 0, -1, 0
# 5, 27, 0 @ 0, -1, 0
# 5, 35, 0 @ 0, -1, 0
# 7, 5, 0 @ 0, -1, 0
# 7, 7, 1 @ 0, -1, 1
# 7, 17, 1 @ 0, -1, 1
# 7, 27, 1 @ 0, -1, 1
# 7, 35, 1 @ 0, -1, 1
# 17, 5, 0 @ 0, -1, 0
# 17, 7, 1 @ 0, -1, 1
# 17, 17, 1 @ 0, -1, 1
# 17, 27, 1 @ 0, -1, 1
# 17, 35, 1 @ 0, -1, 1
# 27, 5, 0 @ 0, -1, 0
# 27, 7, 1 @ 0, -1, 1
# 27, 17, 1 @ 0, -1, 1
# 27, 27, 1 @ 0, -1, 1
# 27, 35, 1 @ 0, -1, 1
# 35, 5, 0 @ 0, -1, 0
# 35, 7, 0 @ 0, -1, 0
# 35, 17, 0 @ 0, -1, 0
# 35, 27, 0 @ 0, -1, 0
# 35, 35, 0 @ 0, -1, 0
# 5, 5, 0 @ 1, 0, 0
# 5, 7, 1 @ 1, 0, 1
# 5, 17, 1 @ 1, 0, 1
# 5, 27, 1 @ 1, 0, 1
# 5, 35, 0 @ 1, 0, 0
# 7, 5, 0 @ 1, 0, 0
# 7, 7, 1 @ 1, 0, 1
# 7, 17, 1 @ 1, 0, 1
# 7, 27, 1 @ 1, 0, 1
# 7, 35, 0 @ 1, 0, 0
# 17, 5, 0 @ 1, 0, 0
# 17, 7, 1 @ 1, 0, 1
# 17, 17, 1 @ 1, 0, 1
# 17, 27, 1 @ 1, 0, 1
# 17, 35, 0 @ 1, 0, 0
# 27, 5, 0 @ 1, 0, 0
# 27, 7, 1 @ 1, 0, 1
# 27, 17, 1 @ 1, 0, 1
# 27, 27, 1 @ 1, 0, 1
# 27, 35, 0 @ 1, 0, 0
# 35, 5, 0 @ 1, 0, 0
# 35, 7, 0 @ 1, 0, 0
# 35, 17, 0 @ 1, 0, 0
# 35, 27, 0 @ 1, 0, 0
# 35, 35, 0 @ 1, 0, 0
# 5, 5, 0 @ -1, 0, 0
# 5, 7, 0 @ -1, 0, 0
# 5, 17, 0 @ -1, 0, 0
# 5, 27, 0 @ -1, 0, 0
# 5, 35, 0 @ -1, 0, 0
# 7, 5, 0 @ -1, 0, 0
# 7, 7, 1 @ -1, 0, 1
# 7, 17, 1 @ -1, 0, 1
# 7, 27, 1 @ -1, 0, 1
# 7, 35, 0 @ -1, 0, 0
# 17, 5, 0 @ -1, 0, 0
# 17, 7, 1 @ -1, 0, 1
# 17, 17, 1 @ -1, 0, 1
# 17, 27, 1 @ -1, 0, 1
# 17, 35, 0 @ -1, 0, 0
# 27, 5, 0 @ -1, 0, 0
# 27, 7, 1 @ -1, 0, 1
# 27, 17, 1 @ -1, 0, 1
# 27, 27, 1 @ -1, 0, 1
# 27, 35, 0 @ -1, 0, 0
# 35, 5, 0 @ -1, 0, 0
# 35, 7, 1 @ -1, 0, 1
# 35, 17, 1 @ -1, 0, 1
# 35, 27, 1 @ -1, 0, 1
# 35, 35, 0 @ -1, 0, 0")
run(__FILE__)
