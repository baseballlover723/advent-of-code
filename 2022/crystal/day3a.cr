require "../../base"

class Year2022::Day3a < Base
  def solve(arg)
    bags = parse_input(arg)
    # puts "bags: #{bags}"

    lower_range = 'a'..'z'
    lower = 'a'.ord
    upper = 'A'.ord
    bags.sum do |p1, p2|
      c = find_dup(p1, p2)
      # puts "c: #{c}"
      if lower_range.includes?(c)
        c.ord - lower + 1
      else
        27 + c.ord - upper
      end
    end
  end

  def find_dup(p1, p2)
    seen = Set(Char).new
    p1.each_char do |c|
      seen << c
    end
    p2.each_char do |c|
      return c if seen.includes?(c)
    end
    '['
  end

  def parse_input(input)
    input.split('\n').map do |str|
      {str[0...(str.size // 2)], str[(str.size // 2)..-1]}
    end
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
