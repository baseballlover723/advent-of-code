require_relative "../../base"

def solve(arg)
  path, map = parse_input(arg)
  # puts "path: #{path}, map: #{map}"

  steps = 0
  path_i = 0
  current = 'AAA'
  while current != 'ZZZ'
    # puts "current: #{current}"
    current = map[current][path[path_i]]
    steps += 1
    path_i += 1
    path_i = 0 if path_i >= path.size
  end

  steps
end

def parse_input(input)
  path_str, maps_strs = input.split("\n\n")

  map = {}
  maps_strs.split("\n").each do |map_str|
    matches = /(?<id>.*?) = \((?<left>.*?), (?<right>.*?)\)/.match(map_str)
    map[matches['id']] = [matches['left'], matches['right']]
  end

  [path_str.chars.map {|c| c == 'L' ? 0 : 1}, map.freeze]
end

return if __FILE__ != $0
# test_run("RL
#
# AAA = (BBB, CCC)
# BBB = (DDD, EEE)
# CCC = (ZZZ, GGG)
# DDD = (DDD, DDD)
# EEE = (EEE, EEE)
# GGG = (GGG, GGG)
# ZZZ = (ZZZ, ZZZ)")

# test_run("LLR
#
# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)")
run(__FILE__)
