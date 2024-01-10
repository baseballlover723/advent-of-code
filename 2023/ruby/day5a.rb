require_relative "../../base"

def solve(arg)
  seeds, maps = parse_input(arg)
  # puts "seeds: #{seeds}"
  # puts "maps: #{maps}"

  maps.each do |name, mappings|
    # puts "name: #{name}, mappings: #{mappings}"
    seeds.map! do |seed|
      get_next_seed(seed, mappings)
    end
  end
  # puts "seeds: #{seeds}"
  seeds.min
end

def get_next_seed(seed, mappings)
  mappings.each do |(src_range, dest)|
    next if !src_range.include?(seed)
    return dest + seed - src_range.begin
  end
  seed
end

def parse_input(input)
  maps = []

  top_split = input.split("\n\n")
  seeds = top_split.shift.split(':')[1].split(' ').map(&:to_i)
  top_split.each do |map_str|
    name_str, *value_strs = map_str.split("\n")
    # puts "value_str: #{value_strs.inspect}"
    name =  name_str[0..(name_str.index(' '))]
    # puts "from: #{from}, to: #{to}"
    values = value_strs.reduce([]) do |acc, value_str|
      dst, src, range = value_str.split(' ').map(&:to_i)
      acc << [(src..(src + range - 1)), dst]
      acc
    end
    maps << [name, values]
  end

  [seeds, maps]
end
# def parse_input(input)
#   maps = Hash.new() {|hsh, k| hsh[k] = Hash.new() {|hsh2, k2| hsh2[k2] = []}}
#
#   top_split = input.split("\n\n")
#   seeds = top_split.shift.split(':')[1].split(' ').map(&:to_i)
#   top_split.each do |map_str|
#     name_str, *value_strs = map_str.split("\n")
#     # puts "value_str: #{value_strs.inspect}"
#     from, to =  name_str[0..(name_str.index(' '))].split("-to-")
#     # puts "from: #{from}, to: #{to}"
#     values = maps[from][to]
#     value_strs.each do |value_str|
#       dst, src, range = value_str.split(' ').map(&:to_i)
#       values << [(src..(src + range - 1)), dst]
#     end
#   end
#
#   [seeds, maps]
# end

return if __FILE__ != $0
# test_run("seeds: 79 14 55 13
#
# seed-to-soil map:
# 50 98 2
# 52 50 48
#
# soil-to-fertilizer map:
# 0 15 37
# 37 52 2
# 39 0 15
#
# fertilizer-to-water map:
# 49 53 8
# 0 11 42
# 42 0 7
# 57 7 4
#
# water-to-light map:
# 88 18 7
# 18 25 70
#
# light-to-temperature map:
# 45 77 23
# 81 45 19
# 68 64 13
#
# temperature-to-humidity map:
# 0 69 1
# 1 0 69
#
# humidity-to-location map:
# 60 56 37
# 56 93 4")
run(__FILE__)
