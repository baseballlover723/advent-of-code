require_relative "../../base"

class Module
  attr_accessor :id
  attr_accessor :dests
  attr_accessor :state

  def initialize(id, dests, state)
    @id = id
    @dests = dests
    @state = state
  end

  def receive_pulse(from, high)
    raise "not implemented"
  end

  def inspect
    "#<#{self.class} id=>#{@id}, dests=>#{@dests}, state=>#{@state}>"
  end
end

class Repeater < Module
  def initialize(id, dests)
    super(id, dests, {})
  end

  def receive_pulse(from, high)
    @dests.map do |d|
      [@id, d, high]
    end
  end
end

class FlipFlop < Module
  def initialize(id, dests)
    super(id, dests, {status: false})
  end

  def receive_pulse(from, high)
    return [] if high
    @state[:status] = !@state[:status]
    @dests.map do |d|
      [@id, d, @state[:status]]
    end
  end
end

class Conjunction < Module
  def initialize(id, dests)
    super(id, dests, {})
  end

  def add_input(iid)
    @state[iid] = false
  end

  def receive_pulse(from, high)
    @state[from] = high
    pulse = !@state.values.all?(true)
    # puts "conjuction: #{@id} sending #{pulse} to #{@dests}, state: #{@state}"
    @dests.map do |d|
      [@id, d, pulse]
    end
  end
end

def solve(arg)
  modules = parse_input(arg)
  # puts "modules: #{modules.inspect}"

  low_pulses_sent = 0
  high_pulses_sent = 0
  # 1.times do |_|
  1000.times do |_|
    new_low, new_high = simulate(modules)
    low_pulses_sent += new_low
    high_pulses_sent += new_high
  end

  # puts "modules: #{modules.inspect}"
  # puts "low_pulses_sent: #{low_pulses_sent}, high_pulses_sent: #{high_pulses_sent}"

  low_pulses_sent * high_pulses_sent
end

def simulate(modules)
  queue = [["broadcaster", "broadcaster", false]]

  low = 0
  high = 0

  while !queue.empty?
    from_id, mod_id, pulse = queue.shift
    mod = modules[mod_id]
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

  [low, high]
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
    modules[id] = create_module(id, dests_str.split(", "), mod)
  end

  modules.values.each do |mod|
    mod.dests.select do |d_id|
      modules[d_id].is_a?(Conjunction)
    end.each do |d_id|
      modules[d_id].add_input(mod.id)
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
