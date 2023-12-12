require "./base"

def solve(arg)
  str_matrix, parts = parse_input(arg)
  # puts "parts: #{parts}"
  # puts "str_matrix: #{str_matrix.inspect}"

  sum = 0
  str_matrix.each.with_index do |row, y|
    row.each_char.with_index do |c, x|
      next if c != '*'
      # next if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
      # puts "c: #{c}, (#{x}, #{y})"
      gears = parts.select do |(numb, x_range, y_range)|
        next false if !x_range.include?(x) || !y_range.include?(y)
        # puts "adding numb: #{numb} because of #{c} at (#{x}, #{y})"
        # sum += numb
        true
      end
      # puts "gears: #{gears}"
      if gears.size == 2
        sum += gears[0][0] * gears[1][0]
      end
    end
  end

  # puts "parts: #{parts.inspect}"

  # puts "parts_set: #{parts_set}"

  # parts_set.sum
  sum
end

def parse_input(input)
  parts = []
  split_input = input.split("\n")
  split_input.each.with_index do |str, y|
    start = nil
    current_numb = ""
    str.each_char.with_index do |c, i|
      if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
        if start.nil?
          start = i
          current_numb = c
        else
          current_numb << c
        end
      else
        if !current_numb.empty?
          s = [start - 1, 0].max
          e = [i, str.size - 1].min
          ys = [y - 1, 0].max
          ye = [y + 1, split_input.size - 1].min
          parts << [current_numb.to_i, (s..e), (ys..ye)]
          start = nil
          current_numb = ""
        end
      end
    end
    if !current_numb.empty?
      s = [start - 1, 0].max
      e = str.size - 1
      ys = [y - 1, 0].max
      ye = [y + 1, split_input.size - 1].min
      parts << [current_numb.to_i, (s..e), (ys..ye)]
    end


  end
  [split_input, parts]
end

return if __FILE__ != $0
# test_run("467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..")
run(__FILE__)
