require "./base"

class Day14a < Base
  def solve(arg)
    field = parse_input(arg)
    # puts "field: #{field}"

    sum = calc_load(field)
    sum
  end

  def calc_load(field)
    sum = 0
    max_y = field.size
    slots = field.map { max_y }
    field.each_with_index do |row, y|
      row.each_with_index do |val, x|
        case val
        when '#'
          slots[x] = max_y - y - 1
        when 'O'
          sum += slots[x]
          slots[x] -= 1
        end
      end
      # break
    end
    sum
  end

  def parse_input(input)
    input.split('\n').map do |str|
      str.chars
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("O....#....
# O.OO#....#
# .....##...
# OO.#O....O
# .O.....O#.
# O.#..O.#.#
# ..O..#O..O
# .......O..
# #....###..
# #OO..#....")
run(__FILE__)
