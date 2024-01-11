require_relative "../../base"

def solve(arg)
  trees = parse_input(arg)
  # puts "trees: #{trees}"
  max_y = trees.size - 2
  max_x = trees[0].size - 2

  bools = Array.new(max_y) { Array.new(max_x, false) }
  # puts "bools:"
  # bools.each do |row|
  #   puts row.inspect
  # end

  (1..max_x).each do |x|
    max_seen = trees[0][x]
    (1..max_y).each do |y|
      if trees[y][x] > max_seen
        max_seen = trees[y][x]
        bools[y - 1][x - 1] = true
        break if max_seen == 9
      end
    end
  end

  (1..max_y).each do |y|
    max_seen = trees[y][0]
    (1..max_x).each do |x|
      if trees[y][x] > max_seen
        max_seen = trees[y][x]
        bools[y - 1][x - 1] = true
        break if max_seen == 9
      end
    end
  end

  (1..max_x).each do |x|
    max_seen = trees[max_y + 1][x]
    max_y.downto(1).each do |y|
      if trees[y][x] > max_seen
        max_seen = trees[y][x]
        bools[y - 1][x - 1] = true
        break if max_seen == 9
      end
    end
  end

  (1..max_y).each do |y|
    max_seen = trees[y][max_x + 1]
    max_x.downto(1).each do |x|
      if trees[y][x] > max_seen
        max_seen = trees[y][x]
        bools[y - 1][x - 1] = true
        break if max_seen == 9
      end
    end
  end

  # puts "bools:"
  # bools.each do |row|
  #   puts row.inspect
  # end

  visible = (trees.size - 1) * 2 + (trees[0].size - 1) * 2
  visible + bools.sum { |row| row.count(true) }
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
