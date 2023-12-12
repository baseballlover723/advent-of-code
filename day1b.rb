require "./base"

LETTERS = {
  1 => "one",
  2 => "two",
  3 => "three",
  4 => "four",
  5 => "five",
  6 => "six",
  7 => "seven",
  8 => "eight",
  9 => "nine",
}

def solve(arg)
  # puts "arg: #{arg}"
  arg.split("\n").map do |word|
    find(word, true) + find(word, false)
  end
  .map(&:to_i).sum
end

def find(word, first)
  queue = LETTERS.map do |val, str|
    chars = str.chars
    chars = chars.reverse if first
    [chars, val.to_s]
  end
  i = first ? 0 : word.size - 1
  while true
    break if (first && i >= word.size) || (!first && i < 0)
    c = word[i]
    # puts "c: #{c}, (#{'0'.ord - c.ord})"
    return c if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
    new_queue = LETTERS.map do |val, str|
      chars = str.chars
      chars = chars.reverse if first
      [chars, val.to_s]
    end
    while !queue.empty?
      chars_left, val = queue.pop
      if chars_left[-1] == c
        chars_left.pop
        return val if chars_left.empty?
        new_queue << [chars_left, val]
      end
    end
    queue = new_queue
    i += first ? 1 : -1
  end
end

return if __FILE__ != $0
# test_run("two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen")
run(__FILE__)
