require_relative "../../base"

def solve(arg)
  edges = parse_input(arg)
  # puts "edges: "
  # edges.each do |from, to|
  #   puts "#{from}: #{to}"
  # end

  wires = calc_wires_to_remove(edges)
  # puts "should remove: #{wires}"
  wires.each do |from, to|
    # puts "deleting #{from} -> #{to}"
    edges[from].delete(to)
    edges[to].delete(from)
  end
  # puts "edges: "
  # edges.each do |from, to|
  #   puts "#{from}: #{to}"
  # end
  size = calc_size(edges, edges.keys[0])
  # puts "size: #{size}"

  size * (edges.size - size)
end

def calc_size(edges, root)
  # puts "root: #{root}"
  seen = Set.new
  queue = [root]
  size = 0
  while !queue.empty?
    node = queue.shift
    next if !seen.add?(node)
    # puts "node: #{node}"
    size += 1
    edges[node].each do |to|
      # puts "#{node} -> #{to}"
      queue << to
    end
  end
  size
end

def calc_wires_to_remove(edges)
  frequencies = find_frequencies(edges)
  # puts "frequencies: #{frequencies.sort_by{|k,v| -v}}"

  cut_above = top_3_unique_vals(frequencies)
  # puts "cut_above: #{cut_above}"
  # exit

  frequencies.select do |edge, count|
    # puts "edge: #{edge}, count: #{count}"
    count >= cut_above
  end.map { |edge, _count| edge }
end

def top_3_unique_vals(hash)
  highest1 = 0
  highest2 = 0
  highest3 = 0
  hash.each do |_, count|
    next if count == highest1 || count == highest2 || count == highest3
    if count > highest1
      highest3 = highest2
      highest2 = highest1
      highest1 = count
    elsif count > highest2
      highest3 = highest2
      highest2 = count
    elsif count > highest3
      highest3 = count
    end
  end
  highest3
end

def find_frequencies(edges)
  frequencies = Hash.new(0)

  edges.each do |from, _|
    update_frequencies(frequencies, edges, from)
  end

  frequencies
end

def update_frequencies(frequencies, edges, root)
  seen = Set.new
  queue = [root]
  seen << root
  while !queue.empty?
    node = queue.shift
    edges[node].each do |to|
      # puts "#{node} -> #{to}"
      next if !seen.add?(to)
      queue << to
      frequencies[[node, to].sort] += 1
    end
  end
end

def parse_input(input)
  edges = Hash.new { |hsh, k| hsh[k] = Set.new }
  input.split("\n").map do |str|
    from, to_str = str.split(": ")
    to_str.split(' ').each do |to|
      edges[from] << to
      edges[to] << from
    end
  end
  edges
end

return if __FILE__ != $0
# test_run("jqt: rhn xhk nvd
# rsh: frs pzl lsr
# xhk: hfx
# cmg: qnr nvd lhk bvb
# rhn: xhk bvb hfx
# bvb: xhk hfx
# pzl: lsr hfx nvd
# qnr: nvd
# ntq: jqt hfx bvb xhk
# nvd: lhk
# lsr: lhk
# rzs: qnr cmg lsr rsh
# frs: qnr lhk lsr")
run(__FILE__)
