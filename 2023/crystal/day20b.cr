require "../../base"

class Year2023::Day20b < Base
  abstract class Module
    getter id : String
    getter dests : Array(String)
    getter state : Hash(String, Bool)

    def initialize(@id : String, @dests : Array(String), @state : Hash(String, Bool))
    end

    abstract def receive_pulse(from, high)

    def inspect
      "#<#{self.class} id=>#{@id}, dests=>#{@dests}, state=>#{@state}>"
    end
  end

  class Repeater < Module
    def initialize(id, dests)
      super(id, dests, {} of String => Bool)
    end

    def receive_pulse(from, high)
      @dests.map do |d|
        {@id, d, high}
      end
    end
  end

  class FlipFlop < Module
    def initialize(id, dests)
      super(id, dests, {"status" => false})
    end

    def receive_pulse(from, high)
      return [] of Tuple(String, String, Bool) if high
      @state["status"] = !@state["status"]
      @dests.map do |d|
        {@id, d, @state["status"]}
      end
    end
  end

  class Conjunction < Module
    def initialize(id, dests)
      super(id, dests, {} of String => Bool)
    end

    def add_input(iid)
      @state[iid] = false
    end

    def receive_pulse(from, high)
      @state[from] = high
      pulse = !@state.values.all?(true)
      # puts "conjuction: #{@id} sending #{pulse} to #{@dests}, state: #{@state}"
      @dests.map do |d|
        {@id, d, pulse}
      end
    end
  end

  def solve(arg)
    modules = parse_input(arg)
    # puts "modules: #{modules.inspect}"

    times = 1_u64
    periods = {"fh" => 0_u64, "mf" => 0_u64, "fz" => 0_u64, "ss" => 0_u64}
    while periods.values.any?(0)
      ql_pulses_sent = simulate(modules)
      # puts "#{times}: #{ql_pulses_sent}"
      ql_pulses_sent.each do |id, saw_high|
        periods[id] = times if periods[id] == 0 && saw_high
      end
      times += 1
      # break if times > 3761
      # break
    end
    # puts "periods: #{periods}"

    lcm = periods.values.reduce(1_u64) do |acc, period|
      acc.lcm(period)
    end

    lcm
  end

  def simulate(modules)
    queue = [{"broadcaster", "broadcaster", false}]

    low = 0
    high = 0
    ql_pulses = {} of String => Bool

    while !queue.empty?
      from_id, mod_id, pulse = queue.shift
      if mod_id == "ql"
        ql_pulses[from_id] = pulse if !ql_pulses[from_id]?
      end
      mod = modules[mod_id]?
      # puts "\n#{from_id} -#{pulse ? "high" : "low"}->#{mod_id} -  low: #{low}, high: #{high}, from_id: #{from_id}, mod: #{mod.inspect}, pulse: #{pulse}"
      if pulse
        high += 1
      else
        low += 1
      end
      next if mod.nil?

      new_pulses = mod.receive_pulse(from_id, pulse)
      # puts "new_pulses: #{new_pulses}"
      queue.concat(new_pulses)
    end

    ql_pulses
  end

  def parse_input(input)
    modules = {} of String => Module
    input.split('\n').each do |str|
      mod = :repeater
      if str[0] == '%'
        mod = :flip_flop
        str = str[1..-1]
      elsif str[0] == '&'
        mod = :conjunction
        str = str[1..-1]
      end
      id, dests_str = str.split(" -> ")
      modules[id] = create_module(id, dests_str.split(", "), mod)
    end

    modules.values.each do |mod|
      mod.dests.select do |d_id|
        modules.has_key?(d_id) && modules[d_id].is_a?(Conjunction)
      end.each do |d_id|
        modules[d_id].as(Conjunction).add_input(mod.id)
      end
    end

    modules
  end

  def create_module(id, dests, type)
    if type == :repeater
      Repeater.new(id, dests)
    elsif type == :flip_flop
      FlipFlop.new(id, dests)
    else
      Conjunction.new(id, dests)
    end
  end
end

stop_if_not_script(__FILE__)
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
