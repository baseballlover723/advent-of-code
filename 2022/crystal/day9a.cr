require "../../base"

class Year2022::Day9a < Base
  def solve(arg)
    dirs = parse_input(arg)
    # puts "dirs: #{dirs}"

    head = StaticArray[0_i16, 0_i16]
    tail = StaticArray[0_i16, 0_i16]
    seen = Set{tail}
    # seen << tail

    dirs.each do |dir|
      # puts ""
      head, tail = simulate!(dir, head, tail, seen)
      # print_graph(head, tail, seen)
    end
    # puts "seen: #{seen}, head: #{head}, tail: #{tail}"

    seen.size
  end

  def simulate!(direction, head, tail, seen)
    # puts "direction: #{direction}, head: #{head}, tail: #{tail}, seen: #{seen}"
    dir, distance = direction
    offset = head.zip(tail).map { |h, t| t - h }
    # puts "offset: #{offset}"
    new_tail = tail

    case dir
    when "U"
      head, new_tail = move_vertical!(1_i8, head, tail, new_tail, distance, seen, offset)
    when "L"
      head, new_tail = move_horizontal!(-1_i8, head, tail, new_tail, distance, seen, offset)
    when "D"
      head, new_tail = move_vertical!(-1_i8, head, tail, new_tail, distance, seen, offset)
    when "R"
      head, new_tail = move_horizontal!(1_i8, head, tail, new_tail, distance, seen, offset)
    end
    {head, new_tail}
  end

  def move_horizontal!(dx, head, tail, new_tail, distance, seen, offset)
    head[0] += dx * distance
    if offset[0] != -1 * dx
      distance -= (offset[0].abs + 1)
    end
    # puts "tail moves: #{distance}"
    if distance > 0
      distance -= 1
      new_tail = tail.clone
      new_tail[0] += dx
      new_tail[1] = head[1]
      seen << new_tail
      # puts "tail: (#{tail[0]}, #{tail[1]}) -> (#{new_tail[0]}, #{new_tail[1]})"
    end
    if distance > 0
      distance.times do |_|
        # puts "tail: (#{new_tail[0]}, #{new_tail[1]}) -> (#{new_tail[0] + dx}, #{new_tail[1]})"
        new_tail = new_tail.clone
        new_tail[0] += dx
        seen << new_tail
      end
    end
    {head, new_tail}
  end

  def move_vertical!(dy, head, tail, new_tail, distance, seen, offset)
    head[1] += dy * distance
    if offset[1] != -1 * dy
      distance -= (offset[1].abs + 1)
    end
    # puts "tail moves: #{distance}"
    if distance > 0
      distance -= 1
      new_tail = tail.clone
      new_tail[0] = head[0]
      new_tail[1] += dy
      seen << new_tail
      # puts "tail: (#{tail[0]}, #{tail[1]}) -> (#{new_tail[0]}, #{new_tail[1]})"
    end
    if distance > 0
      distance.times do |_|
        # puts "tail: (#{new_tail[0]}, #{new_tail[1]}) -> (#{new_tail[0]}, #{new_tail[1] + dy})"
        new_tail = new_tail.clone
        new_tail[1] += dy
        seen << new_tail
      end
    end
    {head, new_tail}
  end

  def print_graph(head, tail, seen)
    5.downto(0).each do |y|
      str = (0..5).map do |x|
        if StaticArray[x, y] == head
          'H'
        elsif StaticArray[x, y] == tail
          'T'
        elsif seen.includes?(StaticArray[x, y])
          '#'
        else
          '.'
        end
      end.join
      puts str
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
run(__FILE__)
