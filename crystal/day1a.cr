require "./base"

class Day1a < Base
  def solve(arg)
    # puts "arg: #{arg}"
    arg.split('\n').map do |word|
      digit = ""
      word.each_char do |c|
        # puts "c: #{c}, (#{'0'.ord - c.ord})"
        if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
          digit += c
          break
        end
      end
      i = word.size - 1
      while i >= 0
        c = word[i]
        if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
          digit += c
          break
        end
        i -= 1
      end
      digit
    end.map(&.to_i).sum
  end
end

stop_if_not_script(__FILE__)
# test_run("1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet")
run(__FILE__)
