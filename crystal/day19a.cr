require "./base"

class Day19a < Base
  def solve(arg)
    workflows, parts = parse_input(arg)
    # puts "workflows: #{workflows}, parts: #{parts}"

    parts.select do |part|
      simulate(workflows, part)
    end.sum do |part|
      part.sum.to_u32
    end
  end

  def simulate(workflows, part)
    state = "in"

    while state != "R" && state != "A"
      # puts "\nstate: #{state}"
      preds = workflows[state]
      preds.each do |(pred, dest)|
        # puts "testing: #{part} -> #{pred} -> #{dest}"
        next if !pred.call(part)
        state = dest
        break
      end
    end

    state == "A"
  end

  def parse_input(input)
    key = {'x' => 0_u8, 'm' => 1_u8, 'a' => 2_u8, 's' => 3_u8}
    top_split = input.split("\n\n")
    workflows = {} of String => Array(Tuple(Proc(Tuple(UInt16, UInt16, UInt16, UInt16), Bool), String))
    top_split[0].split('\n').each do |str|
      brace_start = str.index('{').not_nil!
      id = str[0...brace_start]
      conds_str = str[(brace_start + 1)..-2]
      preds = conds_str.split(',').map do |s|
        colon = s.index(':')
        next {->(variable : Tuple(UInt16, UInt16, UInt16, UInt16)) { true }, s} if colon.nil?

        var = key[s[0]]
        opt = s[1] == '>' ? :gt : :lt
        comp_value = s[2...colon].to_u16
        dest = s[(colon + 1)..-1]
        # puts "var: #{var}, opt: #{opt}, comp_value: #{comp_value}, dest: #{dest}"
        gen_lambda(var, opt, comp_value, dest)
      end

      workflows[id] = preds
    end

    parts = top_split[1].split('\n').map do |str|
      to_tuple(str[1..-2].split(',').map { |s| s[2..-1].to_u16 })
    end
    {workflows, parts}
  end

  def to_tuple(arr : Array(UInt16)) : Tuple(UInt16, UInt16, UInt16, UInt16)
    {arr[0], arr[1], arr[2], arr[3]}
  end

  def gen_lambda(var_i, opt, comp_value, dest)
    if opt == :gt
      {->(variable : Tuple(UInt16, UInt16, UInt16, UInt16)) do
        variable[var_i] > comp_value
      end, dest}
    else
      {->(variable : Tuple(UInt16, UInt16, UInt16, UInt16)) do
        variable[var_i] < comp_value
      end, dest}
    end
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
run(__FILE__)
