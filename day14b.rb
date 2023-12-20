require "./base"

def solve(arg)
  field = parse_input(arg)
  # puts "field:"
  # field.each do |row|
  #   puts row.join
  # end

  times_left = 1_000_000_000
  arr = [field.map { |row| row.map { |val| val } }]
  hash = Hash.new() {|hsh, k| hsh[k] = []}
  hash[arr[0]] << 0
  i = 0
  counts = nil
  while i < times_left
    # times_left.times do |i|
    shift_field_cycle!(field)
    dup = field.map { |row| row.map { |val| val } }
    counts = hash[dup]
    counts << i + 1
    break if counts.size >= 2
    arr << dup
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

  sum = calc_load(arr[new_id])
  sum
end

def shift_field_cycle!(field)
  shift_field_north!(field)
  shift_field_west!(field)
  shift_field_south!(field)
  shift_field_east!(field)
end

def shift_field_north!(field)
  slots = field.map { 0 }
  field.each_with_index do |row, y|
    # puts "\nslots: #{slots}"
    row.each_with_index do |val, x|
      case val
      when "#"
        slots[x] = y + 1
      when "O"
        if slots[x] != y
          # puts "moving col #{x} from y #{y} -> #{slots[x]}"
          field[slots[x]][x] = "O"
          field[y][x] = "."
        end
        slots[x] += 1
      end
    end
  end
  field
end

def shift_field_west!(field)
  slots = field.map { 0 }
  (0...field[0].size).each do |x|
    # puts "\nslots: #{slots}"
    field.each_with_index do |row, y|
      val = row[x]
      case val
      when "#"
        slots[y] = x + 1
      when "O"
        if slots[y] != x
          # puts "moving row #{y} from x #{x} -> #{slots[y]}"
          field[y][slots[y]] = "O"
          field[y][x] = "."
        end
        slots[y] += 1
      end
    end
  end
  field
end

def shift_field_south!(field)
  max_y = field.size - 1
  slots = field.map { max_y }
  field.each_with_index do |row, y|
    y = max_y - y
    row = field[y]
    # puts "\nslots: #{slots}"
    # puts "y: #{y}"
    row.each_with_index do |val, x|
      case val
      when "#"
        slots[x] = y - 1
      when "O"
        if slots[x] != y
          # puts "moving col #{x} from y #{y} -> #{slots[x]}"
          field[slots[x]][x] = "O"
          field[y][x] = "."
        end
        slots[x] -= 1
      end
    end
  end
  field
end

def shift_field_east!(field)
  max_x = field[0].size - 1
  slots = field.map { max_x }
  (0...field[0].size).each do |x|
    x = max_x - x
    # puts "\nslots: #{slots}"
    field.each_with_index do |row, y|
      val = row[x]
      case val
      when "#"
        slots[y] = x - 1
      when "O"
        if slots[y] != x
          # puts "moving row #{y} from x #{x} -> #{slots[y]}"
          field[y][slots[y]] = "O"
          field[y][x] = "."
        end
        slots[y] -= 1
      end
    end
  end
  field
end

def calc_load(field)
  sum = 0
  max_y = field.size
  field.each_with_index do |row, y|
    row.each do |val|
      sum += max_y - y if val == "O"
    end
  end
  sum
end

def parse_input(input)
  input.split("\n").map do |str|
    str.chars
  end
end

return if __FILE__ != $0
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
