require "../../base"

class Year2022::Day5b < Base
  def solve(arg)
    crates, instructions = parse_input(arg)
    # puts "crates: #{crates}, instructions: #{instructions}"

    instructions.each do |numb, from, to|
      crates[to - 1].concat(crates[from - 1].pop(numb))
    end
    # puts "crates: #{crates}"
    crates.map(&.last).join
  end

  def parse_input(input)
    crates_str, instructions_strs = input.split("\n\n")

    crates_strs = crates_str.split('\n')
    crates = [] of Array(Char)
    labels = crates_strs.pop
    numb_cols = (labels.size // 4) + 1
    numb_cols.times do |_|
      crates << [] of Char
    end
    crates_strs.reverse_each do |str|
      numb_cols.times do |i|
        str_i = 4 * i + 1
        next if str_i >= str.size
        crate = str[str_i]
        crates[i] << crate if crate && crate != ' '
      end
    end

    digit_regex = /\d+/
    instructions = instructions_strs.split('\n').map do |str|
      Tuple(Regex::MatchData, Regex::MatchData, Regex::MatchData).from(str.scan(digit_regex)).map { |md| md[0] }.map(&.to_u8)
    end
    {crates, instructions}
  end
end

stop_if_not_script(__FILE__)
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
