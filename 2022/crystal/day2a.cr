require "../../base"

class Year2022::Day2a < Base
  def solve(arg)
    games = parse_input(arg)
    # puts "games: #{games}"

    games.map do |o, p|
      {case o
      when "A" then 1_u16
      when "B" then 2_u16
      when "C" then 3_u16
      else          raise "Invalid move \"#{o}\""
      end,
       case p
       when "X" then 1_u16
       when "Y" then 2_u16
       when "Z" then 3_u16
       else          raise "Invalid move \"#{p}\""
       end,
      }
    end.sum do |o, p|
      result = 0_u16
      if o == p
        result = 3_u16
      elsif p - 1_u16 == o || (p == 1_u16 && o == 3_u16)
        result = 6_u16
      end
      p + result
    end
  end

  def parse_input(input)
    input.split('\n').map do |str|
      Tuple(String, String).from(str.split(' '))
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("A Y
# B X
# C Z")
run(__FILE__)
