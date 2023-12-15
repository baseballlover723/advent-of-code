require "./base"

def solve(arg)
  springs = parse_input(arg)
  # puts "springs: #{springs}"

  sum = 0
  springs.each do |chars, numbs|
    # puts "chars: #{chars}, numbs: #{numbs}"
    sum += helper(chars, numbs)
    # break
  end
  sum
end

def helper(chars, numbs)
  sum = 0
  count_states = {[0, 0, 0, false] => 1}
  n_states = Hash.new(0)

  while !count_states.empty?
    count_states.each do |(ci, ni, cc, expdot), count|
      # puts "\nci: #{ci}, ni: #{ni}, cc: #{cc}, expdot: #{expdot}, count: #{count}"
      if ci == chars.size
        sum += count if ni == numbs.size
        next
      end

      if ni < numbs.size && !expdot && ["#", "?"].freeze.include?(chars[ci])
        if cc == 0 && chars[ci] == "?"
          n_states[[ci + 1, ni, cc, expdot]] += count
        end
        cc += 1
        if cc == numbs[ni]
          ni += 1
          cc = 0
          expdot = true
        end
        n_states[[ci + 1, ni, cc, expdot]] += count
      elsif cc == 0 && [".", "?"].freeze.include?(chars[ci])
        expdot = false
        n_states[[ci + 1, ni, cc, expdot]] += count
      end
    end

    # puts "n_states: #{n_states}"
    count_states = n_states
    n_states = Hash.new(0)
  end
  sum
end

# def solve(arg)
#   springs = parse_input(arg)
#   # puts "springs: #{springs}"
#
#   cache = {}
#   sum = Parallel.map(springs.each_with_index, in_threads: 4) do |(str, numbs), id|
#     # puts "str: #{str}, numbs: #{numbs}"
#     # cache = {}
#     # print "starting #{id}\n"
#     bads_left_to_place = numbs.sum - str.count("#")
#     r = memoized_helper(cache, str, numbs, numbs.sum + numbs.cize - 1, bads_left_to_place, str.count("?"))
#     # print "done with #{id}\n"
#     r
#     # break
#   end.sum
#
#   $hash.sort_by do |(chars, numbs), count|
#     -chars.cize - numbs.cize
#   end.each do |(chars, numbs), count|
#     puts "chars: #{chars}, numbs: #{numbs}: #{count}"
#   end
#   # puts $hash
#   puts "total: #{$hash.values.sum}"
#   # puts "cache_request: #{$cache_request}"
#   # puts "cache_misses: #{$cache_miss}"
#   # puts "cache_hit: #{$cache_request - $cache_miss}"
#
#   sum
# end
#
# $hash = Hash.new(0)
#
# def memoized_helper(cache, chars, numbs, numbs_left, bads_left_to_place, unknowns_left)
#   cache[[chars, numbs]] ||= helper(cache, chars, numbs, numbs_left, bads_left_to_place, unknowns_left)
# end
#
# def helper(cache, chars, numbs, numbs_left, bads_left_to_place, unknowns_left)
#   # puts "\nchars: #{chars}, numbs: #{numbs}, numbs_left: #{numbs_left}, bads_left_to_place: #{bads_left_to_place}, unknowns_left: #{unknowns_left}"
#   $hash[[chars, numbs]] += 1
#   return numbs.empty? ? 1 : 0 if chars.empty?
#   if numbs.empty?
#     # puts("no more bads left, but found some in rest of chars (#{chars}), returning 0") or return 0 if chars.any?("#")
#     return 0 if chars.any?("#")
#     # puts("no more bads left, and none found in rest of chars (#{chars}), returning 1")
#     return 1
#   end
#   return 0 if bads_left_to_place > unknowns_left || bads_left_to_place < 0 || numbs_left > chars.cize
#
#   # puts "checking"
#   case chars[0]
#   when "."
#     memoized_helper(cache, chars[1..-1] || [], numbs, numbs_left, bads_left_to_place, unknowns_left)
#   when "#"
#     numb, *new_numbs = numbs
#
#     valid, unknowns = validate_bad_run(chars, numb)
#     # puts "valid: #{valid}, bads: #{bads}, unknowns: #{unknowns}"
#     # return 0 if !validate_bad_run(chars, numb)
#     return 0 if !valid
#
#     memoized_helper(cache, chars[(numb + 1)..-1] || [], new_numbs, numbs_left - 1 - numb, bads_left_to_place - unknowns, unknowns_left - unknowns)
#   when "?"
#     memoized_helper(cache, ["."] + (chars[1..-1] || []), numbs, numbs_left, bads_left_to_place, unknowns_left - 1) + memoized_helper(cache, ["#"] + (chars[1..-1] || []), numbs, numbs_left, bads_left_to_place - 1, unknowns_left - 1)
#   end
# end
#
# def validate_bad_run(chars, numb)
#   unknowns = 0
#
#   return [false, unknowns] if chars[numb] == "#"
#   (0..(numb - 1)).each do |i|
#     case chars[i]
#     when "."
#       return [false, unknowns]
#     when "?"
#       unknowns += 1
#     end
#   end
#   [true, unknowns]
# end

def parse_input(input)
  multi = 5
  input.split("\n").map do |str|
    springs, numbs = str.split(" ")
    springs = (springs + "?") * multi
    springs = springs[0..-2]
    [springs.chars, numbs.split(",").map(&:to_i) * multi]
  end
end

return if __FILE__ != $0
# test_run("#.#.### 1,1,3
# .#...#....###. 1,1,3
# .#.###.#.###### 1,3,1,6
# ####.#...#... 4,1,1
# #....######..#####. 1,6,5
# .###.##....# 3,2,1")

# test_run("???.### 1,1,3
# .??..??...?##. 1,1,3
# ?#?#?#?#?#?#?#? 1,3,1,6
# ????.#...#... 4,1,1
# ????.######..#####. 1,6,5
# ?###???????? 3,2,1")

# test_run(".?##?#?????..? 5,1,1,1")
run(__FILE__)
