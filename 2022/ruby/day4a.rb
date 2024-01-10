require_relative "../../base"

def solve(arg)
  assignments = parse_input(arg)
  # puts "assignments: #{assignments}"

  overlapping = 0
  assignments.each do |r1, r2|
    overlapping += 1 if r1.cover?(r2) || r2.cover?(r1)
  end
  overlapping
end

def parse_input(input)
  input.split("\n").map do |str|
    str.split(',').map do |s|
      ss, ee = s.split('-').map(&:to_i)
      ss..ee
    end
  end
end

return if __FILE__ != $0
# test_run("2-4,6-8
# 2-3,4-5
# 5-7,7-9
# 2-8,3-7
# 6-6,4-6
# 2-6,4-8")
run(__FILE__)
