require "../../base"

class Year2022::Day1b < Base
  def solve(arg)
    elves = parse_input(arg)
    # puts "elves: #{elves}"

    top_3_vals(elves.map(&.sum)).sum
  end

  def top_3_vals(arr)
    highest1 = 0_u32
    highest2 = 0_u32
    highest3 = 0_u32
    arr.each do |count|
      if count > highest1
        highest3 = highest2
        highest2 = highest1
        highest1 = count
      elsif count > highest2
        highest3 = highest2
        highest2 = count
      elsif count > highest3
        highest3 = count
      end
    end
    {highest1, highest2, highest3}
  end

  def parse_input(input)
    input.split("\n\n").map do |str|
      str.split('\n').map do |s|
        s.to_u32
      end
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("1000
# 2000
# 3000
#
# 4000
#
# 5000
# 6000
#
# 7000
# 8000
# 9000
#
# 10000")
run(__FILE__)
