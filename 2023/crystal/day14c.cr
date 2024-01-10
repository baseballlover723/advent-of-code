require "big"
require "../../base"

# https://www.reddit.com/r/adventofcode/comments/18i0xtn/2023_day_14_solutions/kdauk3g/
class Year2023::Day14c < Base
  def solve(arg)
    field = parse_input(arg)
    # puts "field:"
    # field.each do |row|
    #   puts row.join
    # end

    blocks = BigInt.new(0)
    rocks = BigInt.new(0)
    height = field.size
    width = field[0].size
    field.each do |line|
      line.each_char do |c|
        rocks <<= 1
        blocks <<= 1
        case c
        when '#'
          blocks |= 1
        when 'O'
          rocks |= 1
        end
      end
    end
    size = height * width

    each_row = height.times.reduce(BigInt.new(0)) { |a, c| a << width | 1 }
    each_col = (BigInt.new(1) << width) - 1

    left_col = (BigInt.new(1) << (width - 1)) * each_row
    right_col = 1 * each_row
    top_row = each_col << (size - width)
    bottom_row = 1 * each_col

    times_left = 1_000_000_000
    arr = [rocks]
    hash = Hash(BigInt, Array(Int32)).new() { |hsh, k| hsh[k] = [] of Int32 }
    hash[arr[0]] << 0
    i = 0
    counts = uninitialized Array(Int32)
    while i < times_left
      rocks = shift_field_cycle(rocks, blocks, width, top_row, left_col, bottom_row, right_col)
      counts = hash[rocks]
      counts << i + 1
      break if counts.size >= 2
      arr << rocks
      i += 1
    end
    # puts "i: #{i}"
    diff = counts[1] - counts[0]
    # puts "diff: #{diff}"
    new_id = (times_left - counts[0]) % diff + counts[0]
    # puts "new_id: #{new_id}"

    # hash.each do |field, ids|
    #   puts "ids: #{ids}"
    # end

    sum = calc_load(arr[new_id], width, bottom_row)
    sum
  end

  def shift_field_cycle(rocks, blocks, width, top_row, left_col, bottom_row, right_col)
    rocks = shift_field_north(rocks, blocks, width, top_row)
    rocks = shift_field_west(rocks, blocks, left_col)
    rocks = shift_field_south(rocks, blocks, width, bottom_row)
    rocks = shift_field_east(rocks, blocks, right_col)
    rocks
  end

  def shift_field_north(rocks, blocks, width, top_row)
    loop do
      can_move_up = rocks & ~((blocks | rocks) >> width) & ~top_row
      break if can_move_up == 0
      rocks = rocks & ~can_move_up | can_move_up << width
    end
    rocks
  end

  def shift_field_west(rocks, blocks, left_col)
    loop do
      can_move_left = rocks & ~((blocks | rocks) >> 1) & ~left_col
      break if can_move_left == 0
      rocks = rocks & ~can_move_left | can_move_left << 1
    end
    rocks
  end

  def shift_field_south(rocks, blocks, width, bottom_row)
    loop do
      can_move_down = rocks & ~((blocks | rocks) << width) & ~bottom_row
      break if can_move_down == 0
      rocks = rocks & ~can_move_down | can_move_down >> width
    end
    rocks
  end

  def shift_field_east(rocks, blocks, right_col)
    loop do
      can_move_right = rocks & ~((blocks | rocks) << 1) & ~right_col
      break if can_move_right == 0
      rocks = rocks & ~can_move_right | can_move_right >> 1
    end
    rocks
  end

  def calc_load(rocks, width, bottom_row)
    sum = 0
    y = 1
    while rocks > 0
      row = rocks & bottom_row
      sum += row.popcount * y
      rocks >>= width
      y += 1
    end
    sum
  end

  def parse_input(input)
    input.split('\n')
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
