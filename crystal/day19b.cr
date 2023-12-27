require "./base"

class Day19b < Base
  def solve(arg)
    workflows = parse_input(arg)
    # puts "workflows: #{workflows}"

    accepted_ranges = calc_ranges(workflows)

    # puts "accepted_ranges: #{accepted_ranges}"
    accepted_ranges.sum do |ranges|
      ranges.reduce(1_u64) do |acc, range|
        acc * range.size
      end
    end
  end

  def calc_ranges(workflows)
    accepted = [] of StaticArray(Range(UInt16, UInt16), 4)
    queue = [{"in", StaticArray(Range(UInt16, UInt16), 4).new(1_u16..4000_u16)}]

    while !queue.empty?
      state, ranges = queue.shift
      next if state == "R"
      if state == "A"
        accepted << ranges
        next
      end
      preds, last_dest = workflows[state]
      # puts "\nstate: #{state}, ranges: #{ranges}, preds: #{preds}, last_dest: #{last_dest}"

      preds.each do |i, opt, comp_value, dest|
        range = ranges[i]
        # puts "testing: i: #{i}, opt: #{opt}, comp_value: #{comp_value}, dest: #{dest}, ranges: #{ranges}"
        pass_range = uninitialized Range(UInt16, UInt16)
        fail_range = uninitialized Range(UInt16, UInt16)
        if opt == :gt
          if range.begin > comp_value
            # 200..500 | 100 all pass
            pass_range = range
          elsif range.end > comp_value
            # 200..500 | 250 some pass some fail
            pass_range = ((comp_value + 1)..range.end)
            fail_range = (range.begin..comp_value)
          else
            # 200..500 | 700 all fail
            fail_range = range
          end
        else
          if range.end < comp_value
            # 200..500 | 700 all pass
            # puts "#{range} < #{comp_value}, all_pass"
            pass_range = range
          elsif range.begin < comp_value
            # 200..500 | 250 some pass some fail
            # puts "#{range} < #{comp_value}, some_pass"
            pass_range = (range.begin..(comp_value - 1))
            fail_range = (comp_value..range.end)
          else
            # 200..500 | 100 all fail
            # puts "#{range} < #{comp_value}, none_pass"
            fail_range = range
          end
        end

        # puts "pass_range: #{pass_range}"
        # puts "fail_range: #{fail_range}"
        pass = ranges.clone
        pass[i] = pass_range
        ranges[i] = fail_range
        # puts "#{dest} -> #{pass}"
        queue << {dest, pass}
        # break
      end
      # puts "last #{last_dest} -> #{ranges}"
      queue << {last_dest, ranges}
    end

    # puts "accepted: #{accepted}"

    accepted

    # state == "A"
  end

  def parse_input(input)
    key = {'x' => 0_u8, 'm' => 1_u8, 'a' => 2_u8, 's' => 3_u8}
    top_split = input.split("\n\n")
    workflows = {} of String => Tuple(Array(Tuple(UInt8, Symbol, UInt16, String)), String)
    top_split[0].split('\n').each do |str|
      brace_start = str.index('{').not_nil!
      id = str[0...brace_start]
      conds_str = str[(brace_start + 1)..-2]
      preds = conds_str.split(',').map do |s|
        colon = s.index(':')
        next if colon.nil?

        var = key[s[0]]
        opt = s[1] == '>' ? :gt : :lt
        comp_value = s[2...colon].to_u16
        dest = s[(colon + 1)..-1]
        # puts "var: #{var}, opt: #{opt}, comp_value: #{comp_value}, dest: #{dest}"
        # gen_lambda(var, opt, comp_value, dest)
        {var, opt, comp_value, dest}
      end.compact

      workflows[id] = {preds, conds_str[(conds_str.rindex(',').not_nil! + 1)..-1]}
    end

    workflows
  end
end

stop_if_not_script(__FILE__)
# test_run("px{a<2006:qkq,m>2090:A,rfg}
# pv{a>1716:R,A}
# lnx{m>1548:A,A}
# rfg{s<537:gd,x>2440:R,A}
# qs{s>3448:A,lnx}
# qkq{x<1416:A,crn}
# crn{x>2662:A,R}
# in{s<1351:px,qqz}
# qqz{s>2770:qs,m<1801:hdj,R}
# gd{a>3333:R,R}
# hdj{m>838:A,pv}
#
# {x=787,m=2655,a=1222,s=2876}
# {x=1679,m=44,a=2067,s=496}
# {x=2036,m=264,a=79,s=2244}
# {x=2461,m=1339,a=466,s=291}
# {x=2127,m=1623,a=2188,s=1013}")

# test_run("px{a<2006:A,m>2090:A,R}
# pv{a>1716:R,A}
# lnx{m>1548:A,A}
# rfg{s<537:gd,x>2440:R,A}
# qs{s>3448:A,lnx}
# qkq{x<1416:A,crn}
# crn{x>2662:A,R}
# in{s<1351:px,qqz}
# qqz{s>2770:A,m<1801:A,R}
# gd{a>3333:R,R}
# hdj{m>838:A,pv}
#
# {x=787,m=2655,a=1222,s=2876}
# {x=1679,m=44,a=2067,s=496}
# {x=2036,m=264,a=79,s=2244}
# {x=2461,m=1339,a=466,s=291}
# {x=2127,m=1623,a=2188,s=1013}")
run(__FILE__)
