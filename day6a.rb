require "./base"

def solve(arg)
  races = parse_input(arg)
  # puts "races: #{races}"

  sum = 1
  races.each do |(time, distance)|
    zeros = find_zeros(time, distance)
    # puts "zeros: #{zeros}"
    sum *= zeros[1] - zeros[0] + 1
  end

  sum
end

def find_zeros(time, distance)
  a = -1
  b = time
  c = -distance - 0.1
  back_half = Math.sqrt(b ** 2 - 4 * a * c)
  [((-b + back_half) / (2 * a)).ceil, ((-b - back_half) / (2 * a)).floor]
  # [((-b + back_half) / (2 * a)), ((-b - back_half) / (2 * a))]
end

def parse_input(input)
  times, distances = input.split("\n").map {|str| str.split(':')[1].split(/\s+/).drop(1).map(&:to_i)}

  # puts "times: #{times}"
  # puts "distances: #{distances}"

  times.zip(distances)
end

return if __FILE__ != $0
# test_run("Time:      7  15   30
# Distance:  9  40  200")
run(__FILE__)
