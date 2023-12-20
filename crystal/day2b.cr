require "./base"

class Day2b < Base
  def solve(arg)
    games = parse_input(arg)
    # puts "games: #{games}"

    sum = 0
    games.each do |id, game|
      sum += min_cubes_product(game)
      # sum_ids += id if is_valid?(game)
    end

    sum
  end

  def min_cubes_product(game)
    # puts "game: #{game}"
    max = game.reduce(Hash(String, Int32).new(0)) do |hsh, draw|
      hsh.merge(draw) { |k, old_value, new_value| {old_value, new_value}.max }

      # draw["red"] <= 12 && draw["green"] <= 13 && draw["blue"] <= 14
    end
    # puts "max: #{max}"
    max.values.reduce(1) { |product, value| product * value }
  end

  def parse_input(input)
    games = {} of Int32 => Array(Hash(String, Int32))
    input.split('\n').each do |str|
      id_str, draws_str = str.split(':')
      id = id_str[/\d+/].to_i
      # puts "id: #{id}"
      draws = [] of Hash(String, Int32)
      draws_str.split(';').each do |draw_str|
        draw = Hash(String, Int32).new(0)
        draw_str.strip.split(',').each do |d_str|
          count_str, color = d_str.strip.split(' ')
          draw[color] = count_str.to_i
        end
        draws << draw
      end
      games[id] = draws
    end
    games
  end
end

stop_if_not_script(__FILE__)
# test_run("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
# test_run("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green")
run(__FILE__)
