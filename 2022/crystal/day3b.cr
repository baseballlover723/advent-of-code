require "../../base"

class Year2022::Day3b < Base
  def solve(arg)
    bags = parse_input(arg)
    # puts "bags: #{bags}"

    lower_range = 'a'..'z'
    lower = 'a'.ord
    upper = 'A'.ord
    bags.sum do |(s1, s2, s3)|
      # puts "s1: #{s1}, s2: #{s2}, s3: #{s3}"
      c = find_dup(s1, s2, s3)
      # puts "c: #{c}"
      if lower_range.includes?(c)
        c.ord - lower + 1
      else
        27 + c.ord - upper
      end
    end
  end

  def find_dup(s1, s2, s3)
    seen = Hash(Char, UInt8).new(0_u8)
    s1.each_char do |c|
      seen[c] = 1
    end
    s2.each_char do |c|
      seen[c] = 2 if seen[c] == 1
    end
    s3.each_char do |c|
      return c if seen[c] == 2
    end
    '['
  end

  def parse_input(input)
    input.split('\n').each_slice(3)
  end
end

stop_if_not_script(__FILE__)
# test_run("vJrwpWtwJgWrhcsFMMfFFhFp
# jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
# PmmdzqPrVvPwwTWBwg
# wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
# ttgJtRGJQctTZtZT
# CrZsJsPPZsGzwwsLwLmpwMDw")
run(__FILE__)
