require_relative "../../base"

def solve(arg)
  trees = parse_input(arg)
  # puts "trees: #{trees}"
  max_y = trees.size - 2
  end_y = trees.size - 1
  max_x = trees[0].size - 2
  end_x = trees[0].size - 1

  tree_counts = Array.new(max_y) { Array.new(max_x) { [0, 0, 0, 0] } }
  # puts "tree_counts:"
  # tree_counts.each do |row|
  #   puts row.inspect
  # end

  (1..max_x).each do |x|
    (1..max_y).each do |y|
      # puts "\n(#{x}, #{y}): #{trees[y][x]}"
      yy = y - 1
      count = 0
      while yy >= 0 && trees[y][x] > trees[yy][x]
        # puts "testing yy: #{yy}, #{trees[y][x]} (#{y}) > #{trees[yy][x]} (#{yy}) => #{trees[y][x] > trees[yy][x]}"
        count += 1
        yy -= 1
      end
      count += 1 if yy >= 0
      # puts "count: #{count}, yy: #{yy}"
      tree_counts[y - 1][x - 1][0] = count
    end
  end

  (1..max_y).each do |y|
    (1..max_x).each do |x|
      # puts "\n(#{x}, #{y}): #{trees[y][x]}"
      xx = x - 1
      count = 0
      while xx >= 0 && trees[y][x] > trees[y][xx]
        # puts "testing xx: #{xx}, #{trees[y][x]} (#{x}) > #{trees[y][xx]} (#{xx}) => #{trees[y][x] > trees[y][xx]}"
        count += 1
        xx -= 1
      end
      count += 1 if xx >= 0
      # puts "count: #{count}, xx: #{xx}"
      tree_counts[y - 1][x - 1][1] = count
    end
  end

  (1..max_x).each do |x|
    max_y.downto(1).each do |y|
      # puts "\n(#{x}, #{y}): #{trees[y][x]}"
      yy = y + 1
      count = 0
      while yy <= end_y && trees[y][x] > trees[yy][x]
        # puts "testing yy: #{yy}, #{trees[y][x]} (#{y}) > #{trees[yy+1][x]} (#{yy+1}) => #{trees[y][x] > trees[yy+1][x]}"
        count += 1
        yy += 1
      end
      count += 1 if yy <= end_y
      # puts "count: #{count}, yy: #{yy}"
      tree_counts[y - 1][x - 1][2] = count
    end
  end

  (1..max_y).each do |y|
    max_x.downto(1).each do |x|
      # puts "\n(#{x}, #{y}): #{trees[y][x]}"
      xx = x + 1
      count = 0
      while xx <= end_x && trees[y][x] > trees[y][xx]
        # puts "testing xx: #{xx}, #{trees[y][x]} (#{x}) > #{trees[y][xx]} (#{xx}) => #{trees[y][x] > trees[y][xx]}"
        count += 1
        xx += 1
      end
      count += 1 if xx <= end_x
      # puts "count: #{count}, xx: #{xx}"
      tree_counts[y - 1][x - 1][3] = count
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

  tree_counts.flatten(1).select do |nt, wt, st, et|
    nt != 0 && wt != 0 && st != 0 && et != 0
  end.map do |nt, wt, st, et|
    nt * wt * st * et
  end.max
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
