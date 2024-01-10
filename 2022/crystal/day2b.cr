require "../../base"

class Year2022::Day2b < Base
  def solve(arg)
    games = parse_input(arg)
    # puts "games: #{games}"

    games.sum do |o, p|
      result, play = case p
                     when "X" then {0_u16, 0_u16}
                     when "Y" then {3_u16, 1_u16}
                     when "Z" then {6_u16, 2_u16}
                     else          raise "Invalid move \"#{p}\""
                     end
      oppo = case o
             when "A" then 0_u16
             when "B" then 1_u16
             when "C" then 2_u16
             else          raise "Invalid move \"#{o}\""
             end
      play = (play + (oppo % 3_u16)) % 3_u16
      play += 3_u16 if play == 0_u16
      # puts "play: #{play}"
      play + result
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
# test_run("B Y
# C X
# A Z")
# test_run("C Y
# A X
# B Z")
run(__FILE__)
