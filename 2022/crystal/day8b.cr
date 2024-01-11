require "../../base"

class Year2022::Day8b < Base
  def solve(arg)
    trees = parse_input(arg)
    # puts "trees: #{trees}"
    max_y = trees.size - 2
    end_y = trees.size - 1
    max_x = trees[0].size - 2
    end_x = trees[0].size - 1

    tree_counts = Array.new(max_y) { Array(StaticArray(UInt8, 4)).new(max_x) { StaticArray(UInt8, 4).new(0_u8) } }
    # puts "tree_counts:"
    # tree_counts.each do |row|
    #   puts row.inspect
    # end

    (1..max_x).each do |x|
      (1..max_y).each do |y|
        # puts "\n(#{x}, #{y}): #{trees[y][x]}"
        yy = y - 1
        count = 0_u8
        while yy >= 0 && trees[y][x] > trees[yy][x]
          # puts "testing yy: #{yy}, #{trees[y][x]} (#{y}) > #{trees[yy][x]} (#{yy}) => #{trees[y][x] > trees[yy][x]}"
          count += 1
          yy -= 1
        end
        count += 1 if yy >= 0
        # puts "count: #{count}, yy: #{yy}"
        arr = tree_counts[y - 1][x - 1]
        arr[0] = count
        tree_counts[y - 1][x - 1] = arr
      end
    end

    (1..max_y).each do |y|
      (1..max_x).each do |x|
        # puts "\n(#{x}, #{y}): #{trees[y][x]}"
        xx = x - 1
        count = 0_u8
        while xx >= 0 && trees[y][x] > trees[y][xx]
          # puts "testing xx: #{xx}, #{trees[y][x]} (#{x}) > #{trees[y][xx]} (#{xx}) => #{trees[y][x] > trees[y][xx]}"
          count += 1
          xx -= 1
        end
        count += 1 if xx >= 0
        # puts "count: #{count}, xx: #{xx}"
        arr = tree_counts[y - 1][x - 1]
        arr[1] = count
        tree_counts[y - 1][x - 1] = arr
      end
    end

    (1..max_x).each do |x|
      max_y.downto(1).each do |y|
        # puts "\n(#{x}, #{y}): #{trees[y][x]}"
        yy = y + 1
        count = 0_u8
        while yy <= end_y && trees[y][x] > trees[yy][x]
          # puts "testing yy: #{yy}, #{trees[y][x]} (#{y}) > #{trees[yy+1][x]} (#{yy+1}) => #{trees[y][x] > trees[yy+1][x]}"
          count += 1
          yy += 1
        end
        count += 1 if yy <= end_y
        # puts "count: #{count}, yy: #{yy}"
        arr = tree_counts[y - 1][x - 1]
        arr[2] = count
        tree_counts[y - 1][x - 1] = arr
      end
    end

    (1..max_y).each do |y|
      max_x.downto(1).each do |x|
        # puts "\n(#{x}, #{y}): #{trees[y][x]}"
        xx = x + 1
        count = 0_u8
        while xx <= end_x && trees[y][x] > trees[y][xx]
          # puts "testing xx: #{xx}, #{trees[y][x]} (#{x}) > #{trees[y][xx]} (#{xx}) => #{trees[y][x] > trees[y][xx]}"
          count += 1
          xx += 1
        end
        count += 1 if xx <= end_x
        # puts "count: #{count}, xx: #{xx}"
        arr = tree_counts[y - 1][x - 1]
        arr[3] = count
        tree_counts[y - 1][x - 1] = arr
      end
    end

    # puts "tree_counts:"
    # tree_counts.each do |row|
    #   puts row.inspect
    # end

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
