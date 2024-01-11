require_relative "../../base"

def solve(arg)
  trees = parse_input(arg)
  # puts "trees: #{trees}"
  max_y = trees.size - 1
  max_x = trees[0].size - 1

  dp = Array.new(trees.size) { Array.new(trees[0].size) { [-1, -1, -1, -1] } }

  (0..max_x).each do |x|
    max_seen = -1
    (1..max_y).each do |y|
      max_seen = trees[y - 1][x] if trees[y - 1][x] > max_seen
      dp[y][x][0] = max_seen
    end
  end

  (0..max_y).each do |y|
    max_seen = -1
    (1..max_x).each do |x|
      max_seen = trees[y][x - 1] if trees[y][x - 1] > max_seen
      dp[y][x][1] = max_seen
    end
  end

  (0..max_x).each do |x|
    max_seen = -1
    (max_y - 1).downto(0).each do |y|
      max_seen = trees[y + 1][x] if trees[y + 1][x] > max_seen
      dp[y][x][2] = max_seen
    end
  end

  (0..max_y).each do |y|
    max_seen = -1
    (max_x - 1).downto(0).each do |x|
      max_seen = trees[y][x + 1] if trees[y][x + 1] > max_seen
      dp[y][x][3] = max_seen
    end
  end

  # puts "dp:"
  # dp.each do |row|
  #   puts row.inspect
  # end

  visible = 0
  trees.each_with_index do |row, y|
    row.each_with_index do |height, x|
      # puts "(#{x}, #{y}): #{height}, #{dp[y][x]}"
      visible += 1 if dp[y][x].any? { |oh| height > oh }
      # puts "visible" if dp[y][x].any? {|oh| height > oh}
    end
  end

  visible
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
run(__FILE__)
