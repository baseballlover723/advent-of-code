require "../../base"

class Year2022::Day8d < Base
  def solve(arg)
    trees = parse_input(arg)
    # puts "trees: #{trees}"
    max_y = trees.size - 2
    max_x = trees[0].size - 2

    tree_counts = Array.new(max_y) { Array(StaticArray(UInt8, 4)).new(max_x) { StaticArray(UInt8, 4).new(0_u8) } }
    # puts "tree_counts:"
    # tree_counts.each do |row|
    #   puts row.inspect
    # end

    chain = StaticArray(UInt8, 10).new(1_u8)
    (1..max_x).each do |x|
      chain.fill(1_u8)
      (1..max_y).each do |y|
        height = trees[y][x]
        # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
        arr = tree_counts[y - 1][x - 1]
        arr[0] = chain[height]
        tree_counts[y - 1][x - 1] = arr
        increment!(chain, height)
        # puts "chain: #{chain}"
      end
    end

    (1..max_y).each do |y|
      chain.fill(1_u8)
      (1..max_x).each do |x|
        height = trees[y][x]
        # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
        arr = tree_counts[y - 1][x - 1]
        arr[1] = chain[height]
        tree_counts[y - 1][x - 1] = arr
        increment!(chain, height)
      end
    end

    (1..max_x).each do |x|
      chain.fill(1_u8)
      max_y.downto(1).each do |y|
        height = trees[y][x]
        # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
        arr = tree_counts[y - 1][x - 1]
        arr[2] = chain[height]
        tree_counts[y - 1][x - 1] = arr
        increment!(chain, height)
      end
    end

    (1..max_y).each do |y|
      chain.fill(1_u8)
      max_x.downto(1).each do |x|
        height = trees[y][x]
        # puts "\n(#{x}, #{y}): #{height} => #{chain[height]}\nchain: #{chain}"
        arr = tree_counts[y - 1][x - 1]
        arr[3] = chain[height]
        tree_counts[y - 1][x - 1] = arr
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

    max = 0_u32
    tree_counts.each do |rows|
      rows.each do |row|
        next if row.any?(0_u8)
        prod = row.product(1_u32)
        max = prod if prod > max
      end
    end
    max
  end

  macro increment!(chain, height)
    (({{height}} + 1)...{{chain}}.size).each do |i|
      {{chain}}[i] += 1
    end
    %i = {{height}}
    while %i >= 0 && {{chain}}[%i] != 1
      {{chain}}[%i] = 1
      %i -= 1
    end
end

  def parse_input(input)
    input.split('\n').map do |str|
      str.chars.map(&.to_u8)
    end
  end
end

stop_if_not_script(__FILE__)
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
