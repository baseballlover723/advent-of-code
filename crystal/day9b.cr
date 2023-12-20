require "./base"

class Day9b < Base
  def solve(arg)
    values = parse_input(arg)
    # puts "values: #{values}"

    sum = 0
    values.each do |vals|
      n = calc_next(vals)
      # puts "vals: #{vals}, next: #{n}"
      sum += n
    end

    sum
  end

  def calc_next(vals)
    sum = vals.first
    multi = -1
    while vals.size >= 2
      diffs = [] of Int32
      vals.each_cons(2) do |(v1, v2)|
        diffs << v2 - v1
      end
      # puts "diffs: #{diffs}"
      sum += diffs.first * multi
      break if diffs.all?(diffs[0])
      multi *= -1
      vals = diffs
    end
    sum
  end

  def parse_input(input)
    input.split('\n').map { |str| str.split(' ').map(&.to_i) }
  end
end

stop_if_not_script(__FILE__)
# test_run("0 3 6 9 12 15
# 1 3 6 10 15 21
# 10 13 16 21 30 45")
run(__FILE__)
