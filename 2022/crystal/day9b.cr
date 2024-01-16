require "../../base"

class Year2022::Day9b < Base
  OFFSET_RANGE = -1..1

  def solve(arg)
    dirs = parse_input(arg)
    # puts "dirs: #{dirs}"

    snake = StaticArray(StaticArray(Int16, 2), 10).new { StaticArray[0_i16, 0_i16] }
    seen = Set{snake[-1].clone}

    dirs.each do |dir|
      snake = simulate!(dir, snake, seen)
      # print_graph(snake, seen)
      # break
    end
    # puts "snake: #{snake}"
    # print_graph(snake, seen)
    # puts "seen: #{seen}, head: #{head}, tail: #{tail}"

    seen.size
  end

  def simulate!(direction, snake, seen)
    # puts "direction: #{direction}, snake: #{snake}, seen: #{seen}"
    # print_graph(snake, seen)
    dir, distance = direction

    case dir
    when "U"
      distance.times do
        head = snake[0]
        head[1] += 1_i16
        snake[0] = head
        snake = iterate_snake!(snake) do |head, tail, last|
          move!(head, tail, seen, last)
          # print_graph(snake, seen)
        end
      end
    when "L"
      distance.times do
        head = snake[0]
        head[0] -= 1_i16
        snake[0] = head
        snake = iterate_snake!(snake) do |head, tail, last|
          move!(head, tail, seen, last)
          # print_graph(snake, seen)
        end
      end
    when "D"
      distance.times do
        head = snake[0]
        head[1] -= 1_i16
        snake[0] = head
        snake = iterate_snake!(snake) do |head, tail, last|
          move!(head, tail, seen, last)
          # print_graph(snake, seen)
        end
      end
    when "R"
      distance.times do
        head = snake[0]
        head[0] += 1_i16
        snake[0] = head
        snake = iterate_snake!(snake) do |head, tail, last|
          move!(head, tail, seen, last)
          # print_graph(snake, seen)
        end
      end
    end
    snake
  end

  def iterate_snake!(snake)
    (snake.size - 2).times do |i|
      # puts "i: #{i}"
      new_tail = yield snake[i], snake[i + 1], false
      return snake if new_tail.nil?
      snake[i + 1] = new_tail
    end
    new_tail = yield snake[-2], snake[-1], true
    snake[-1] = new_tail if new_tail
    snake
  end

  def move!(head, tail, seen, last)
    offset = {head[0] - tail[0], head[1] - tail[1]}
    # puts "offset: #{offset}"

    x_offset_ok = OFFSET_RANGE.includes?(offset[0])
    y_offset_ok = OFFSET_RANGE.includes?(offset[1])
    # puts "x_offset_ok: #{x_offset_ok}, y_offset_ok: #{y_offset_ok}"
    return nil if x_offset_ok && y_offset_ok
    # old_x = tail[0]
    # old_y = tail[1]
    tail[0] += offset[0] <=> 0
    tail[1] += offset[1] <=> 0
    # puts "(#{old_x}, #{old_y}) -> (#{new_tail[0]}, #{new_tail[1]}), offset: #{offset}"
    seen << tail.clone if last
    tail
  end

  def print_graph(snake, seen)
    map = Array.new(5) { Array.new(6, ".") }
    # map = Array.new(21) { Array.new(26, ".") }
    offset_x = {seen.map { |arr| arr[0] }.min, snake.map { |arr| arr[0] }.min}.min * -1
    offset_y = {seen.map { |arr| arr[1] }.min, snake.map { |arr| arr[1] }.min}.min * -1
    # puts "offset_x: #{offset_x}, offset_y: #{offset_y}"
    seen.each do |(x, y)|
      x += offset_x
      y += offset_y
      map[y][x] = "#"
    end
    snake.each.with_index.to_a.reverse.each do |(x, y), i|
      # i = snake.size - i - 1
      x += offset_x
      y += offset_y
      i = "H" if i <= 0
      map[y][x] = i.to_s
    end
    map.reverse_each do |row|
      puts row.join
    end
  end

  def parse_input(input)
    input.split('\n').map do |str|
      dir_str, dis_str = str.split(' ')
      distance = dis_str.to_i8
      {dir_str, distance}
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("R 4
# U 4
# L 3
# D 1
# R 4
# D 1
# L 5
# R 2")
# test_run("R 5
# U 8
# L 8
# D 3
# R 17
# D 10
# L 25
# U 20")
# test_run("R 4
# U 4")
run(__FILE__)
