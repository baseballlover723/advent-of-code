require_relative "../../base"

def solve(arg)
  modules = parse_input(arg)
  # puts "modules: #{modules.inspect}"

  periods = modules["broadcaster"][2].map do |d_id|
    calc_number(modules, d_id)
  end
  # puts "periods: #{periods}"

  lcm = periods.reduce(1) do |acc, period|
    acc.lcm(period)
  end

  lcm
end

def calc_number(modules, start_mod_id)
  conjunction_dests = modules[start_mod_id][2].map do |mod_id|
    modules[mod_id]
  end.select do |(type, mod_id, dests)|
    type == :conjunction
  end[0][2].to_set
  # puts "conjunction_dests: #{conjunction_dests}"

  mod_id = start_mod_id
  i = 0
  numb = 1
  while mod_id
    type, mod_id, dests = modules[mod_id]
    # puts "mod_id: #{mod_id}, type: #{type}, not_include: #{!conjunction_dests.include?(mod_id)}, dests: #{dests}, numb: #{numb.to_s(2)} (#{numb})"
    numb += 1 << i if !conjunction_dests.include?(mod_id)

    mod_id = dests.find do |d_id|
      modules[d_id][0] == :flip_flop
    end
    i += 1
  end
  numb
end

def parse_input(input)
  modules = {}
  input.split("\n").each do |str|
    mod = :repeater
    if str[0] == '%'
      mod = :flip_flop
      str = str[1..-1]
    elsif str[0] == '&'
      mod = :conjunction
      str = str[1..-1]
    end
    id, dests_str = str.split(" -> ")
    modules[id] = [mod, id, dests_str.split(", ")]
  end

  modules
end

return if __FILE__ != $0
# test_run("broadcaster -> a, b, c
# %a -> b
# %b -> c
# %c -> inv
# &inv -> a")
# test_run("broadcaster -> a
# %a -> inv, con
# &inv -> b
# %b -> con
# &con -> output")
run(__FILE__)
