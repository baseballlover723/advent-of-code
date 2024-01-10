require "../../base"

class Year2023::Day1b < Base
  LETTERS = {
    '1' => "one".chars,
    '2' => "two".chars,
    '3' => "three".chars,
    '4' => "four".chars,
    '5' => "five".chars,
    '6' => "six".chars,
    '7' => "seven".chars,
    '8' => "eight".chars,
    '9' => "nine".chars,
  }

  LETTERS_REVERSED = LETTERS.map { |val, chars| {val, chars.reverse} }.to_h

  def solve(arg)
    # puts "arg: #{arg}"
    arg.split('\n').map do |word|
      find(word, true) + find(word, false)
    end
      .map(&.to_i).sum
  end

  def find(word, first)
    map = first ? LETTERS : LETTERS_REVERSED
    queue = map.map do |val, chars|
      {chars, 0, val}
    end
    i = first ? 0 : word.size - 1
    increment = first ? 1 : -1
    while true
      break if (first && i >= word.size) || (!first && i < 0)
      c = word[i]
      # puts "c: #{c}, (#{'0'.ord - c.ord})"
      return c.to_s if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
      new_queue = map.map do |val, chars|
        {chars, 0, val}
      end
      while !queue.empty?
        chars, ci, val = queue.pop
        if chars[ci] == c
          ci += 1
          return val.to_s if ci == chars.size
          new_queue << {chars, ci, val}
        end
      end
      queue = new_queue
      i += increment
    end
    ""
  end
end

stop_if_not_script(__FILE__)
# test_run("two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen")
run(__FILE__)
