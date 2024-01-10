require_relative "../../base"

def solve(arg)
  games = parse_input(arg)
  # puts "games: #{games}"

  games.map do |o, p|
    [case o
     when "A" then 1
     when "B" then 2
     when "C" then 3
     end,
     case p
     when "X" then 1
     when "Y" then 2
     when "Z" then 3
     end
    ]
  end.sum do |o, p|
    result = 0
    if o == p
      result = 3
    elsif p - 1 == o || (p == 1 && o == 3)
      result = 6
    end
    p + result
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
run(__FILE__)
