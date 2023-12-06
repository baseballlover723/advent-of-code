require "./base"

def solve(arg)
  time, distance = parse_input(arg)
  # puts "time: #{time}, distance: #{distance}"
  zeros = find_zeros(time, distance)
  # puts "zeros: #{zeros}"
  zeros[1] - zeros[0] + 1
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
  time, distance = input.split("\n").map {|str| str.split(":")[1].split(/\s+/).join("").to_i}

  # puts "times: #{times}"
  # puts "distances: #{distances}"

  # times.zip(distances)
  [time, distance]
end

# test_run("Time:      7  15   30
# Distance:  9  40  200")
run(__FILE__)
