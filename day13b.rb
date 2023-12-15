require "./base"

def solve(arg)
  rocks = parse_input(arg)
  # puts "rocks: #{rocks}"

  sum = 0
  rocks.each do |rock|
    sum += find_reflection(rock)
    # break
  end
  sum
end

def find_reflection(rocks)
  # puts "rocks"
  # rocks.each do |row|
  #   puts row
  # end
  # puts "\nnew_rocks"
  # new_rocks = transpose(rocks)
  # new_rocks.each do |row|
  #   puts row
  # end

  row = find_reflection_row(rocks)
  # puts "row: #{row}"
  return 100 * row if row

  # puts "\n**************************\n\n"
  col = find_reflection_col(rocks)
  # puts "col: #{col}"
  return col if col
end

def transpose(rocks)
  max_y = rocks.size - 1
  max_x = rocks[0].size - 1
  new_rocks = Array.new(max_x + 1) { Array.new(max_y + 1) }
  rocks.each_with_index do |row, y|
    row.each_char.with_index do |v, x|
      new_rocks[x][y] = v
    end
  end
  new_rocks.map! do |row|
    row.join
  end
  new_rocks
end

def find_reflection_row(rocks)
  rocks.each_with_index.each_cons(2) do |(row1, i1), (row2, i2)|
    # puts "checking if same rows: #{i1}, #{i2}"
    mods_needed = check_rows_same(row1, row2, 2)
    # puts "mods_needed: #{mods_needed}"
    next if mods_needed >= 2
    return i2 if test_reflection_row(rocks, i1, mods_needed)
  end
  nil
end

def check_rows_same(row1, row2, max)
  diffs = 0
  (0...row1.size).each do |i|
    diffs += 1 if row1[i] != row2[i]
    return diffs if diffs >= max
  end
  diffs
end

def test_reflection_row(rocks, row_i, mods_needed)
  # puts "testing reflection between rows #{row_i} - #{row_i + 1}"
  up_i = row_i - 1
  down_i = row_i + 2

  while up_i >= 0 && down_i < rocks.size
    mods_needed += check_rows_same(rocks[up_i], rocks[down_i], 2 - mods_needed)
    # puts "checking #{up_i} & #{down_i}, mods_needed: #{mods_needed}"
    return false if mods_needed >= 2
    up_i -= 1
    down_i += 1
  end
  # puts "mods_needed: #{mods_needed}"
  mods_needed == 1
end

def find_reflection_col(rocks)
  (0...(rocks[0].size - 1)).each do |col_i|
    # puts "checking if same cols: #{col_i}, #{col_i + 1}"
    mods_needed = check_cols_same(rocks, col_i, col_i + 1, 2)
    # puts "mods_needed: #{mods_needed}"
    next if mods_needed >= 2
    return col_i + 1 if test_reflection_col(rocks, col_i, mods_needed)
    # puts "found reflection col: #{col_i + 1}" if test_reflection_col(rocks, col_i)
  end
  nil
end

def check_cols_same(rocks, i1, i2, max)
  diffs = 0
  (0...rocks.size).each do |row_i|
    diffs += 1 if rocks[row_i][i1] != rocks[row_i][i2]
    return diffs if diffs >= max
  end
  diffs
end

def test_reflection_col(rocks, col_i, mods_needed)
  # puts "testing reflection between cols #{col_i} - #{col_i + 1}"
  left_i = col_i - 1
  right_i = col_i + 2

  while left_i >= 0 && right_i < rocks[0].size
    mods_needed += check_cols_same(rocks, left_i, right_i, 2 - mods_needed)
    # puts "checking #{left_i} & #{right_i}, mods_needed: #{mods_needed}"
    return false if mods_needed >= 2
    left_i -= 1
    right_i += 1
  end
  # puts "end mods_needed: #{mods_needed} #{col_i} - #{col_i + 1}"
  mods_needed == 1
end

def parse_input(input)
  input.split("\n\n").map do |str|
    str.split("\n")
  end
end

return if __FILE__ != $0
# test_run("#.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.
#
# #...##..#
# #....#..#
# ..##..###
# #####.##.
# #####.##.
# ..##..###
# #....#..#")

# test_run("....#....##..##..
# ##.#.....#....#..
# ....##...#.##.#..
# ..##..#####..####
# ###..##..######..
# .....##.#.#..#.#.
# .#.#####.##..##.#
# ###.###...####...
# ....####.#....#.#")

run(__FILE__)
