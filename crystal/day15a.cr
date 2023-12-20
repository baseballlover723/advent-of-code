require "./base"

class Day15a < Base
  def solve(arg)
    strs = parse_input(arg)
    # puts "strs: #{strs}"

    sum = 0
    strs.each do |str|
      sum += hash(str)
    end

    sum
  end

  def hash(str)
    hash = 0
    str.each_char do |c|
      hash += c.ord
      hash *= 17
      hash %= 256
    end

    hash
  end

  def parse_input(input)
    input.split(',')
  end
end

stop_if_not_script(__FILE__)
# test_run("HASH")
# test_run("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7")
run(__FILE__)
