require_relative "../../base"

def solve(arg)
  elves = parse_input(arg)
  # puts "elves: #{elves}"

  elves.map(&:sum).max
end

def parse_input(input)
  input.split("\n\n").map do |str|
    str.split("\n").map do |s|
      s.to_i
    end
  end
end

return if __FILE__ != $0
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
