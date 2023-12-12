require "./base"

def solve(arg)
  path, map = parse_input(arg)
  # puts "path: #{path}, map: #{map}"
  currents = map.keys.filter {|id| id.end_with?('A')}
  # puts "currents: #{currents}"

  lcm = nil
  steps = 0
  path_i = 0
  while !currents.empty?
    # puts "currents: #{currents}"
    currents.reject! do |current|
      if current.end_with?('Z')
        # puts "found cycle at #{steps}"
        if lcm.nil?
          lcm = steps
        else
          lcm = lcm.lcm(steps)
        end
        true
      else
        false
      end
    end
    # puts "current: #{current}"
    currents.map! do |current|
      map[current][path[path_i]]
    end
    steps += 1
    path_i += 1
    path_i = 0 if path_i >= path.size
  end

  lcm
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
# test_run("LR
#
# 11A = (11B, XXX)
# 11B = (XXX, 11Z)
# 11Z = (11B, XXX)
# 22A = (22B, XXX)
# 22B = (22C, 22C)
# 22C = (22Z, 22Z)
# 22Z = (22B, 22B)
# XXX = (XXX, XXX)")

run(__FILE__)
