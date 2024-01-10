require_relative "../../base"

def solve(arg)
  elves = parse_input(arg)
  # puts "elves: #{elves}"

  top_3_vals(elves.map(&:sum)).sum
end

def top_3_vals(arr)
  highest1 = 0
  highest2 = 0
  highest3 = 0
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
  [highest1, highest2, highest3]
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
