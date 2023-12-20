require "./base"

ZERO = '0'.ord unless defined? ZERO

def solve(arg)
  str_matrix, parts = parse_input(arg)
  # puts "parts: #{parts}"
  # puts "str_matrix: #{str_matrix.inspect}"

  sum = 0
  str_matrix.each.with_index do |row, y|
    found_symbol = false
    row.each_char.with_index do |c, x|
      next if c == '.' || (c.ord - ZERO >= 0 && c.ord - ZERO < 10)
      # puts "c: #{c}, (#{x}, #{y})"
      if !found_symbol
        numb_parts_to_trim = calc_parts_to_trim(parts, y)
        parts.shift(numb_parts_to_trim)
        found_symbol = true
      end
      parts.reject! do |(numb, x_range, y_range)|
        break if y < y_range.begin
        next false if !x_range.include?(x)
        # puts "adding numb: #{numb} because of #{c} at (#{x}, #{y})"
        sum += numb
        true
      end
    end
  end

  # puts "parts: #{parts.inspect}"

  # puts "parts_set: #{parts_set}"

  # parts_set.sum
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
# test_run("*..
# .1.
# ...
# .*.
# .2.
# ...
# ..*
# .3.
# ...
# ...
# *4.
# ...
# ...
# .5*
# ...
# ...
# .6.
# *..
# ...
# .7.
# .*.
# ...
# .8.
# ..*")

# test_run("1..\n*..")
# test_run("2..\n.*.")
# test_run("3..\n..*")
# test_run(".4.\n*..")
# test_run(".5.\n.*.")
# test_run(".6.\n..*")
# test_run("..7\n*..")
# test_run("..8\n.*.")
# test_run("..9\n..*")

# test_run("*..\n1..")
# test_run(".*.\n2..")
# test_run("..*\n3..")
# test_run("*..\n.4.")
# test_run(".*.\n.5.")
# test_run("..*\n.6.")
# test_run("*..\n..7")
# test_run(".*.\n..8")
# test_run("..*\n..9")
# test_run(".46.\n..*.")

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
