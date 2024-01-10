require_relative "../../base"

def solve(arg)
  crates, instructions = parse_input(arg)
  # puts "crates: #{crates}, instructions: #{instructions}"

  instructions.each do |numb, from, to|
    numb.times do |_|
      # puts "moving #{crates[from - 1].last} from #{from - 1} -> #{to - 1}"
      crates[to - 1] << crates[from - 1].pop
    end
  end
  # puts "crates: #{crates}"
  crates.map(&:last).join
end

def parse_input(input)
  crates_str, instructions_strs = input.split("\n\n")

  crates_strs = crates_str.split("\n")
  crates = []
  labels = crates_strs.pop
  numb_cols = (labels.size / 4) + 1
  numb_cols.times do |_|
    crates << []
  end
  crates_strs.reverse_each do |str|
    numb_cols.times do |i|
      crate = str[4 * i + 1]
      crates[i] << crate if crate && crate != ' '
    end
  end

  digit_regex = /\d+/
  instructions = instructions_strs.split("\n").map do |str|
    str.scan(digit_regex).map(&:to_i)
  end
  [crates, instructions]
end

return if __FILE__ != $0
# test_run("    [D]
# [N] [C]
# [Z] [M] [P]
#  1   2   3
#
# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2")
run(__FILE__)
