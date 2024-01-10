require_relative "../../base"

def solve(arg)
  bags = parse_input(arg)
  # puts "bags: #{bags}"

  lower_range = 'a'..'z'
  lower = 'a'.ord
  upper = 'A'.ord
  bags.sum do |s1, s2, s3|
    # puts "s1: #{s1}, s2: #{s2}, s3: #{s3}"
    c = find_dup(s1, s2, s3)
    # puts "c: #{c}"
    if lower_range.include?(c)
      c.ord - lower + 1
    else
      27 + c.ord - upper
    end
  end
end

def find_dup(s1, s2, s3)
  seen = Hash.new(0)
  s1.each_char do |c|
    seen[c] = 1
  end
  s2.each_char do |c|
    seen[c] = 2 if seen[c] == 1
  end
  s3.each_char do |c|
    return c if seen[c] == 2
  end
end

def parse_input(input)
  input.split("\n").each_slice(3)
end

return if __FILE__ != $0
# test_run("vJrwpWtwJgWrhcsFMMfFFhFp
# jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
# PmmdzqPrVvPwwTWBwg
# wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
# ttgJtRGJQctTZtZT
# CrZsJsPPZsGzwwsLwLmpwMDw")
run(__FILE__)
