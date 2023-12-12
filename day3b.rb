require "./base"

ZERO = '0'.ord unless defined? ZERO

def solve(arg)
  str_matrix, parts = parse_input(arg)
  # puts "parts: #{parts}"
  # puts "str_matrix: #{str_matrix.inspect}"

  sum = 0
  str_matrix.each.with_index do |row, y|
    found_star = false
    row.each_char.with_index do |c, x|
      next if c != '*'
      # next if c.ord - '0'.ord >= 0 && c.ord - '0'.ord < 10
      # puts "c: #{c}, (#{x}, #{y})"
      if !found_star
        numb_parts_to_trim = calc_parts_to_trim(parts, y)
        parts.shift(numb_parts_to_trim)
        found_star = true
      end

      gears = []
      parts.each do |(numb, x_range, y_range)|
        break if y < y_range.begin
        next if !x_range.include?(x)
        # puts "adding numb: #{numb} because of #{c} at (#{x}, #{y})"
        # sum += numb
        gears << numb
        break if gears.size > 2
      end
      # puts "gears: #{gears}"
      if gears.size == 2
        sum += gears[0] * gears[1]
      end
    end
  end

  # puts "parts: #{parts.inspect}"
  sum
end

def calc_parts_to_trim(parts, y)
  parts.bsearch_index do |(numb, x_range, y_range)|
    y <= y_range.end
  end || 0
end

def parse_input(input)
  parts = []
  split_input = input.split("\n")
  split_input.each.with_index do |str, y|
    start = nil
    current_numb = ""
    str.each_char.with_index do |c, i|
      if c.ord - ZERO >= 0 && c.ord - ZERO < 10
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
