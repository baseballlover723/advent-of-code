require_relative "../../base"

def solve(arg)
  trees = parse_input(arg)
  # puts "trees: #{trees}"
  max_y = trees.size - 2
  max_x = trees[0].size - 2

  tree_counts = Array.new(max_y) { Array.new(max_x) { [0, 0, 0, 0] } }
  # puts "tree_counts:"
  # tree_counts.each do |row|
  #   puts row.inspect
  # end

  (1..max_x).each do |x|
    chain = Array.new(10, 1)
    (1..max_y).each do |y|
      height = trees[y][x]
      # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
      tree_counts[y - 1][x - 1][0] = chain[height]
      increment!(chain, height)
      # puts "chain: #{chain}"
    end
  end

  (1..max_y).each do |y|
    chain = Array.new(10, 1)
    (1..max_x).each do |x|
      height = trees[y][x]
      # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
      tree_counts[y - 1][x - 1][1] = chain[height]
      increment!(chain, height)
    end
  end

  (1..max_x).each do |x|
    chain = Array.new(10, 1)
    max_y.downto(1).each do |y|
      height = trees[y][x]
      # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
      tree_counts[y - 1][x - 1][2] = chain[height]
      increment!(chain, height)
    end
  end

  (1..max_y).each do |y|
    chain = Array.new(10, 1)
    max_x.downto(1).each do |x|
      height = trees[y][x]
      # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
      tree_counts[y - 1][x - 1][3] = chain[height]
      increment!(chain, height)
    end
  end

  # puts "tree_counts:"
  # tree_counts.each do |row|
  #   puts row.inspect
  # end
  # puts print_tree(trees, tree_counts, 7,2)

  # puts "products: "
  # tree_counts.each do |row|
  #   arr = row.map do |nt, wt, st, et|
  #     nt*wt*st*et
  #   end.to_a
  #   puts arr.inspect
  # end

  tree_counts.flatten(1).select do |nt, wt, st, et|
    nt != 0 && wt != 0 && st != 0 && et != 0
  end.map do |nt, wt, st, et|
    nt * wt * st * et
  end.max
end

def increment!(chain, height)
  ((height + 1)...chain.size).each do |i|
    chain[i] += 1
  end
  i = height
  while i >= 0 && chain[i] != 1
    chain[i] = 1
    i -= 1
  end
end

def parse_input(input)
  input.split("\n").map do |str|
    str.chars.map(&:to_i)
  end
end

return if __FILE__ != $0
# test_run("30373
# 25512
# 65332
# 33549
# 35390")
# test_run("37373
# 24512
# 65332
# 33549
# 07600
# 35390")
# test_run("0211001210
# 2121122003
# 0011121320
# 1010111023
# 1202013310
# 1112011332
# 2102203013
# 0022200100
# 1100221020
# 1011221333")
run(__FILE__)
