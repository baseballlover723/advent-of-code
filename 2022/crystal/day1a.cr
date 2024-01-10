require "../../base"

class Year2022::Day1a < Base
  def solve(arg)
    elves = parse_input(arg)
    # puts "elves: #{elves}"

    elves.map(&.sum).max
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
