require_relative "../../base"

def solve(arg)
  games = parse_input(arg)
  # puts "games: #{games}"

  games.sum do |o, p|
    result, play = case p
                   when "X" then [0, 0]
                   when "Y" then [3, 1]
                   when "Z" then [6, 2]
                   end
    oppo = case o
           when "A" then 0
           when "B" then 1
           when "C" then 2
           end
    play = (play + (oppo % 3)) % 3
    play += 3 if play == 0
    # puts "play: #{play}"
    play + result
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    str.split(' ')
  end
end

return if __FILE__ != $0
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
