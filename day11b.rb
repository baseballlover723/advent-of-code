require "./base"

def solve(arg)
  galaxies = parse_input(arg)
  # puts "galaxies: #{galaxies}"

  sum = 0
  galaxies.combination(2) do |g1, g2|
    sum += mat_distance(g1, g2)
  end
  sum
end

def mat_distance(g1, g2)
  x1, y1 = g1
  x2, y2 = g2
  (x2 - x1).abs + (y2 - y1).abs
end

def parse_input(input)
  space = input.split("\n")

  empty_cols = (0...space[0].size).to_a.select do |i|
    space.all? {|row| row[i] == '.'}
  end
  empty_rows = (0...space.size).select do |i|
    !space[i].index('#')
    # row.all? {|c| c == '.'}
  end
  # puts "empty_cols: #{empty_cols}"
  # puts "empty_rows: #{empty_rows}"

  galaxies = []
  offset_y = 0
  iy = 0
  # expansion = 9
  # expansion = 99
  expansion = 999_999
  space.each_with_index do |row, y|
    if iy < empty_rows.size && y == empty_rows[iy]
      offset_y += expansion
      iy += 1
      next
    end
    offset_x = 0
    ix = 0
    last_i = 0
    while (x = row.index('#', last_i))
      last_i = x + 1
      while ix < empty_cols.size && x >= empty_cols[ix]
        offset_x += expansion
        ix += 1
      end
      galaxies << [x + offset_x, y + offset_y]
    end
  end

  galaxies
end

return if __FILE__ != $0
# test_run("...#......
# .......#..
# #.........
# ..........
# ......#...
# .#........
# .........#
# ..........
# .......#..
# #...#.....")
run(__FILE__)
