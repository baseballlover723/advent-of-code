require "./base"

class Day22a < Base
  class Brick
    getter x_range : Range(UInt16, UInt16)
    getter y_range : Range(UInt16, UInt16)
    getter z_range : Range(UInt16, UInt16)
    getter supporting_bricks : Set(Brick)
    getter bricks_on_top : Set(Brick)
    getter id : String | Int32

    def initialize(@x_range, @y_range, @z_range, @id)
      @supporting_bricks = Set(Brick).new
      @bricks_on_top = Set(Brick).new
    end

    def fall!(new_z_start)
      return if new_z_start == @z_range.begin
      distance = @z_range.begin - new_z_start
      @z_range = (@z_range.begin - distance)..(@z_range.end - distance)
    end

    def add_supporting_brick(brick)
      @supporting_bricks << brick if brick && brick.z_range.end + 1 == @z_range.begin
    end

    def add_brick_on_top(brick)
      @bricks_on_top << brick if @z_range.end + 1 == brick.z_range.begin
    end

    def can_destroy?
      bricks_on_top.all? do |b|
        b.supporting_bricks.size >= 2
      end
    end

    def inspect
      "#< @id=#{id}, @x_range=#{@x_range}, @y_range=#{@y_range}, @z_range=#{@z_range}, @supporting_bricks=Set#{@supporting_bricks.map { |b| b.id }}>, @bricks_on_top=Set#{@bricks_on_top.map { |b| b.id }}>"
    end
  end

  def solve(arg)
    bricks, max_x, max_y = parse_input(arg)
    # puts "bricks:"
    # bricks.each do |b|
    #   puts b.inspect if inverted(b.x_range) || inverted(b.y_range) || inverted(b.z_range)
    # end
    # puts "max: (#{max_x}, #{max_y})"

    bricks = calc_gravity(bricks, max_x, max_y)

    # puts "bricks:"
    # bricks.each do |b|
    #   # puts "Prism(Polygon((#{b.x_range.begin},#{b.y_range.begin},#{b.z_range.begin}),(#{b.x_range.end+1},#{b.y_range.begin},#{b.z_range.begin}),(#{b.x_range.end+1},#{b.y_range.end+1},#{b.z_range.begin}),(#{b.x_range.begin},#{b.y_range.end+1},#{b.z_range.begin})),#{b.z_range.size})"
    #   puts b.inspect
    # end

    # puts "bricks.size: #{bricks.size}"

    safe_bricks = Set(Brick).new
    bricks.each do |brick|
      safe_bricks << brick if brick.can_destroy?
    end

    safe_bricks.size
  end

  def calc_gravity(bricks, max_x, max_y)
    cross_section = Array.new(max_y + 1) { Array(Brick?).new(max_x + 1, nil) }

    bricks.each do |brick|
      # puts brick.inspect
      new_z_start = lowest_cross_section(cross_section, brick)
      # puts "z_start: #{brick.z_range.begin} => #{new_z_start}"
      brick.fall!(new_z_start)
      place_cross_section!(cross_section, brick)
      # puts brick.inspect
      # puts "cross_section: "
      # cross_section.each do |row|
      #   puts row.map { |b| b&.z_range&.end || 0 }.inspect
      # end
    end

    # puts "cross_section: "
    # cross_section.each do |row|
    #   puts row.inspect
    # end

    bricks
  end

  def lowest_cross_section(cross_section, brick)
    max = 0
    brick.x_range.each do |x|
      brick.y_range.each do |y|
        supporting_brick = cross_section[y][x]
        next if supporting_brick.nil?
        max = supporting_brick.z_range.end if supporting_brick.z_range.end > max
      end
    end
    max + 1
  end

  def place_cross_section!(cross_section, brick)
    brick.x_range.each do |x|
      brick.y_range.each do |y|
        supporting_brick = cross_section[y][x]
        if supporting_brick
          brick.add_supporting_brick(supporting_brick)
          supporting_brick.add_brick_on_top(brick)
        end
        cross_section[y][x] = brick
      end
    end
  end

  def parse_input(input)
    max_x = 0_u16
    max_y = 0_u16
    bricks = input.split('\n').map do |str|
      str.split('~').map do |s|
        s.split(',').map(&.to_u16)
      end
    end.map_with_index do |((x1, y1, z1), (x2, y2, z2)), i|
      max_x = x2 if x2 > max_x
      max_y = y2 if y2 > max_y
      # Brick.new(x1..x2, y1..y2, z1..z2, calc_id(i))
      Brick.new(x1..x2, y1..y2, z1..z2, i)
    end.sort_by do |brick|
      brick.z_range.begin
    end
    {bricks, max_x, max_y}
  end

  def calc_id(i)
    id = ""
    while i >= 26
      ii = i % 26
      id += ('A'.ord + ii).chr
      i /= 26
      i -= 1
    end
    id += ('A'.ord + i).chr
    id.reverse
  end
end

stop_if_not_script(__FILE__)
# test_run("1,0,1~1,2,1
# 0,0,2~2,0,2
# 0,2,3~2,2,3
# 0,0,4~0,2,4
# 2,0,5~2,2,5
# 0,1,6~2,1,6
# 1,1,8~1,1,9")
# test_run("1,0,1~1,2,1
# 0,0,2~2,0,2
# 0,2,3~2,2,3
# 0,0,4~0,2,4
# 2,0,5~2,2,5
# 0,1,6~2,1,6
# 1,1,8~1,1,9
# 0,1,2~0,1,5")
# test_run("0,0,1~0,0,1
# 1,0,1~2,0,1
# 0,0,2~1,0,2
# 2,0,2~2,0,2")
run(__FILE__)
