require_relative "../../base"

def solve(arg)
  hail = parse_input(arg)
  # puts "hail: #{hail}"

  rock_pos = calc_rock(hail.first(5))

  rock_pos.sum
end

def calc_rock(hails)
  # puts "hails: #{hails}"

  coefficients = []
  rhs = []

  # Get px0, py0, dx0, dy0
  hails.each_cons(2) do |h1, h2|
    px1, py1, _, dx1, dy1, _ = h1
    px2, py2, _, dx2, dy2, _ = h2
    coefficients << [dy2 - dy1, dx1 - dx2, py1 - py2, px2 - px1]
    rhs << -px1 * dy1 + py1 * dx1 + px2 * dy2 - py2 * dx2
  end

  px0, py0, dx0, dy0 = gaussian_elimination(coefficients, rhs)

  # puts "px0: #{px0}, py0: #{py0}, dx0: #{dx0}, dy0: #{dy0}"

  coefficients = []
  rhs = []
  hails[0...3].each_cons(2) do |h1, h2|
    px1, _, pz1, dx1, _, dz1 = h1
    px2, _, pz2, dx2, _, dz2 = h2

    coefficients << [dx1 - dx2, px2 - px1]
    rhs << -px1 * dz1 + pz1 * dx1 + px2 * dz2 - pz2 * dx2 -((dz2 - dz1) * px0) - ((pz1 - pz2) * dx0)
  end

  pz0, dz0 = gaussian_elimination(coefficients, rhs)
  # puts "px0: #{px0.to_i}, py0: #{py0.to_i}, pz0: #{pz0.to_i}, dx0: #{dx0.to_i}, dy0: #{dy0.to_i}, dz0: #{dz0.to_i}"

  [px0.to_i, py0.to_i, pz0.to_i]
end

# https://github.com/ash42/adventofcode/blob/main/adventofcode2023/src/nl/michielgraat/adventofcode2023/day24/Day24.java
def gaussian_elimination(coefficients, rhs)
  coefficients.each_with_index do |row, i|
    # Select pivot
    pivot = row[i]

    # Normalize row i
    row.map! do |val|
      val / pivot
    end
    rhs[i] /= pivot

    # Sweep using row i
    coefficients.each_with_index do |new_row, k|
      next if k == i

      factor = new_row[i]
      new_row.map!.with_index do |val, j|
        val - factor * row[j]
      end

      rhs[k] -= factor * rhs[i]
    end
  end
  rhs
end

def parse_input(input)
  input.split("\n").lazy.map do |str|
    str.split(" @ ").map do |s|
      s.split(", ").map(&:to_i).map(&:to_r)
    end.flatten
  end
end

return if __FILE__ != $0
# test_run("19, 13, 30 @ -2,  1, -2
# 18, 19, 22 @ -1, -1, -2
# 20, 25, 34 @ -2, -2, -4
# 12, 31, 28 @ -1, -2, -1
# 20, 19, 15 @  1, -5, -3")
run(__FILE__)
