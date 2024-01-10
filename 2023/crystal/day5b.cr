require "../../base"

class Year2023::Day5b < Base
  def solve(arg)
    seeds, maps = parse_input(arg)
    # puts "seeds: #{seeds}"
    # puts "maps: #{maps}"

    maps.each do |name, mappings|
      # puts "name: #{name}"
      # puts "name: #{name}, mappings: #{mappings}"
      seeds = seeds.flat_map do |seed|
        get_next_seed(seed, mappings)
      end
      # break
    end
    # puts "seeds: #{seeds}"
    seeds.map(&.begin).min
  end

  def get_next_seed(seed, mappings)
    # puts "seed: #{seed}, mappings: #{mappings}"
    seeds = [seed]
    new_seeds = [] of Range(Int64, Int64)

    mappings.each do |(src_range, dest)|
      seeds = seeds.flat_map do |seed_range|
        # puts "seed_range: #{seed_range}, src_range: #{src_range}"
        case {src_range.includes?(seed_range.begin), src_range.includes?(seed_range.end)}
        in {true, true}
          # puts "begin_in, end_in (1 new range, 0 extra ranges)"
          new_seeds << ((dest + seed_range.begin - src_range.begin)..(dest + seed_range.end - src_range.begin))
          [] of Range(Int64, Int64)
        in {false, true}
          # puts "begin_out, end_in"
          new_seeds << ((dest)..(dest + seed_range.end - src_range.begin))
          [seed_range.begin..src_range.begin - 1]
        in {true, false}
          # puts "begin_in, end_out"
          new_seeds << ((dest + seed_range.begin - src_range.begin)..(dest + src_range.size - 1))
          [(src_range.end + 1)..seed_range.end]
        in {false, false}
          # puts "begin_out, end_out (no overlap)"
          seed_range
        end
      end
    end
    # puts "new_seeds: #{new_seeds}, seeds: #{seeds}"

    new_seeds.concat(seeds)
  end

  def parse_input(input)
    maps = [] of Tuple(String, Array(Tuple(Range(Int64, Int64), Int64)))

    top_split = input.split("\n\n")
    seeds = top_split.shift.split(':')[1].split(' ', remove_empty: true).map(&.to_i64).each_slice(2).map do |(start, length)|
      (start..(start + length - 1))
    end.to_a
    top_split.each do |map_str|
      name_str, *value_strs = map_str.split('\n')
      # puts "value_str: #{value_strs.inspect}"
      name = name_str[0..(name_str.index(' '))]
      # puts "from: #{from}, to: #{to}"
      values = value_strs.reduce([] of Tuple(Range(Int64, Int64), Int64)) do |acc, value_str|
        dst, src, range = value_str.split(' ', remove_empty: true).map(&.to_i64)
        acc << {(src..(src + range - 1)), dst}
        acc
      end
      maps << {name, values}
    end

    {seeds, maps}
  end
  # def parse_input(input)
  #   maps = Hash.new() {|hsh, k| hsh[k] = Hash.new() {|hsh2, k2| hsh2[k2] = []}}
  #
  #   top_split = input.split("\n\n")
  #   seeds = top_split.shift.split(':')[1].split(' ').map(&.to_i)
  #   top_split.each do |map_str|
  #     name_str, *value_strs = map_str.split('\n')
  #     # puts "value_str: #{value_strs.inspect}"
  #     from, to =  name_str[0..(name_str.index(' '))].split("-to-")
  #     # puts "from: #{from}, to: #{to}"
  #     values = maps[from][to]
  #     value_strs.each do |value_str|
  #       dst, src, range = value_str.split(' ').map(&.to_i)
  #       values << [(src..(src + range - 1)), dst]
  #     end
  #   end
  #
  #   [seeds, maps]
  # end
end

stop_if_not_script(__FILE__)
# def test(seed_range)
#   mappings = [[30..60, 130]]
#   r = get_next_seed(seed_range, mappings)
#   puts "#{seed_range} => #{r}"
# end
#
# test(10..20)
# test(70..90)
#
# test(39..49)
# test(40..50)
# test(41..51)
#
# test(19..39)
# test(20..40)
# test(21..41)
#
# test(49..69)
# test(50..70)
# test(51..71)

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
