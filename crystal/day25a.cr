require "./base"

class Day25a < Base
  def solve(arg)
    edges = parse_input(arg)
    # puts "edges: "
    # edges.each_with_index do |to, from|
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
    size = calc_size(edges, 0)
    # puts "size: #{size}"

    size * (edges.size - size)
  end

  def calc_size(edges : Array(Set(UInt16)), root : UInt16) : UInt32
    # puts "root: #{root}"
    seen = Array.new(edges.size, false)
    queue = [root]
    size = 0_u32
    while !queue.empty?
      node = queue.shift
      next if seen[node]
      seen[node] = true
      # puts "node: #{node}"
      size += 1_u32
      edges[node].each do |to|
        # puts "#{node} -> #{to}"
        queue << to
      end
    end
    size
  end

  def calc_wires_to_remove(edges : Array(Set(UInt16))) : Array(Tuple(UInt16, UInt16))
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

  def top_3_unique_vals(hash : Hash(T, UInt16)) : UInt16 forall T
    highest1 = 0_u16
    highest2 = 0_u16
    highest3 = 0_u16
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

  def find_frequencies(edges : Array(Set(UInt16))) : Hash(Tuple(UInt16, UInt16), UInt16)
    frequencies = Hash(Tuple(UInt16, UInt16), UInt16).new(0_u16)

    (0_u16...edges.size).each do |from|
      update_frequencies(frequencies, edges, from)
    end

    frequencies
  end

  def update_frequencies(frequencies : Hash(Tuple(UInt16, UInt16), UInt16), edges : Array(Set(UInt16)), root : UInt16) : Nil
    # def update_frequencies(frequencies, edges, root)
    seen = Array.new(edges.size, false)
    queue = [root]
    seen[root] = true
    while !queue.empty?
      node = queue.shift
      edges[node].each do |to|
        # puts "#{node} -> #{to}"
        next if seen[to]
        seen[to] = true
        queue << to
        frequencies[node < to ? {node, to} : {to, node}] += 1_u16
      end
    end
  end

  def parse_input(input)
    edges = [] of Set(UInt16)
    id = 0_u16
    id_hash = Hash(String, UInt16).new { |hsh, k| hsh[k] = (id += 1_u16) - 1_u16 }
    input.split('\n').map do |str|
      from_str, tos_str = str.split(": ")
      from = id_hash[from_str]
      edges << Set(UInt16).new if from >= edges.size
      tos_str.split(' ').each do |to_str|
        to = id_hash[to_str]
        edges << Set(UInt16).new if to >= edges.size
        edges[from] << to
        edges[to] << from
      end
    end
    edges
  end
end

stop_if_not_script(__FILE__)
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
