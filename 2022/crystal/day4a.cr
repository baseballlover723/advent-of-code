require "../../base"

class Year2022::Day4a < Base
  def solve(arg)
    assignments = parse_input(arg)
    # puts "assignments: #{assignments}"

    overlapping = 0_u16
    assignments.each do |r1, r2|
      overlapping += 1_u16 if (r1.includes?(r2.begin) && r1.includes?(r2.end)) || (r2.includes?(r1.begin) && r2.includes?(r1.end))
    end
    overlapping
  end

  def parse_input(input)
    input.split('\n').map do |str|
      Tuple(String, String).from(str.split(',')).map do |s|
        ss, ee = s.split('-').map(&.to_u8)
        ss..ee
      end
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("2-4,6-8
# 2-3,4-5
# 5-7,7-9
# 2-8,3-7
# 6-6,4-6
# 2-6,4-8")
run(__FILE__)
