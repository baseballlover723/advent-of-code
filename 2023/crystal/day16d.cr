require "../../base"

# https://www.reddit.com/r/adventofcode/comments/18jjpfk/2023_day_16_solutions/kdmkw4f/
class Year2023::Day16d < Base
  def solve(arg)
    matrix = parse_input(arg)

    max_mirror_energy(matrix)
  end

  class Traversal
    getter layout : Array(UInt8)
    getter rows : UInt8
    getter cols : UInt8

    UP    = 1_u8
    RIGHT = 2_u8
    DOWN  = 4_u8
    LEFT  = 8_u8

    SPLITTER_HORIZ = 0_u8
    SPLITTER_VERT  = 1_u8
    MIRROR_FWD     = 2_u8
    MIRROR_BWD     = 3_u8
    OPEN           = 4_u8

    def initialize(layout, rows, cols)
      @layout = layout
      @rows = rows
      @cols = cols
    end

    def clone
      Traversal.new(@layout.clone, @rows, @cols)
    end

    def energized
      traverse(0, 0, RIGHT)
    end

    def idx(row, col)
      row.to_u16 * @cols + col
    end

    def step(row, col, dir)
      case dir
      when UP
        return nil if row.zero?
        {row - 1, col}
      when RIGHT
        return nil if col == @cols - 1
        {row, col + 1}
      when DOWN
        return nil if row == @rows - 1
        {row + 1, col}
      when LEFT
        return nil if col.zero?
        {row, col - 1}
      else
        raise "Invalid direction"
      end
    end

    def traverse(row, col, dir)
      energized = 0
      # puts "row: #{row}, col: #{col}, dir: #{dir}"

      loop do
        idx = idx(row, col)
        curr = @layout[idx] & 0xF
        visited = @layout[idx] >> 4

        break if (dir & visited) != 0

        if visited.zero?
          energized += 1
        end

        @layout[idx] |= dir << 4

        case curr
        when Traversal::SPLITTER_HORIZ
          if dir == Traversal::UP || dir == Traversal::DOWN
            step_r = step(row, col, Traversal::LEFT)
            if (step_r)
              r, c = step_r
              energized += traverse(r, c, Traversal::LEFT)
            end
            dir = Traversal::RIGHT
          end
        when Traversal::SPLITTER_VERT
          if dir == Traversal::LEFT || dir == Traversal::RIGHT
            step_r = step(row, col, Traversal::UP)
            if (step_r)
              r, c = step_r
              energized += traverse(r, c, Traversal::UP)
            end
            dir = Traversal::DOWN
          end
        when Traversal::MIRROR_FWD
          case dir
          when Traversal::UP    then dir = Traversal::RIGHT
          when Traversal::RIGHT then dir = Traversal::UP
          when Traversal::DOWN  then dir = Traversal::LEFT
          when Traversal::LEFT  then dir = Traversal::DOWN
          else
            raise "Invalid dir"
          end
        when Traversal::MIRROR_BWD
          case dir
          when Traversal::UP    then dir = Traversal::LEFT
          when Traversal::RIGHT then dir = Traversal::DOWN
          when Traversal::DOWN  then dir = Traversal::RIGHT
          when Traversal::LEFT  then dir = Traversal::UP
          else
            raise "Invalid dir"
          end
        else
        end

        step_r = step(row, col, dir)
        if (step_r)
          r, c = step_r
          row = r
          col = c
        else
          break
        end
      end

      energized
    end
  end

  def mirror_energy(input)
    input.clone.energized
  end

  def max_mirror_energy(input)
    traversals = [] of Tuple(UInt8, UInt8, UInt8)
    (0_u8...input.rows).each do |r|
      traversals.push({r, 0_u8, Traversal::RIGHT})
      traversals.push({r, input.cols - 1, Traversal::LEFT})
    end
    (0_u8...input.cols).each do |c|
      traversals.push({0_u8, c, Traversal::DOWN})
      traversals.push({input.rows - 1, c, Traversal::UP})
    end

    traversals
      .map { |(r, c, d)| input.clone.traverse(r, c, d) }
      .max
  end

  def parse_input(input)
    cols = (input.index('\n') || 0_u8).to_u8
    rows = (input.size / cols).to_u8
    layout = input.chars
      .reject { |b| b == '\n' } # Filter out newlines
      .map do |b|
        case b
        when '-'  then Traversal::SPLITTER_HORIZ
        when '|'  then Traversal::SPLITTER_VERT
        when '/'  then Traversal::MIRROR_FWD
        when '\\' then Traversal::MIRROR_BWD
        when '.'  then Traversal::OPEN
        else
          raise "Invalid elem"
        end
      end

    # puts "layout: #{layout}"

    Traversal.new(layout, rows, cols)

    # input.split("\n").map do |str|
    #   str.chars
    # end
  end
end

stop_if_not_script(__FILE__)
# test_run(".|...\\....
# |.-.\\.....
# .....|-...
# ........|.
# ..........
# .........\\
# ..../.\\\\..
# .-.-/..|..
# .|....-|.\\
# ..//.|....")
run(__FILE__)
