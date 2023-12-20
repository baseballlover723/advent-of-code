require "./base"

class Day4b < Base
  def solve(arg)
    cards = parse_input(arg)
    # puts "cards: #{cards}"

    copies = cards.map { 1 }
    cards.each.with_index do |(id, card), i|
      matches = card[:numbers] & card[:winning]
      # puts "#{id}: #{matches}"
      next if matches.empty?
      matches.size.times do |ci|
        copies[i + ci + 1] += copies[i]
      end
    end
    copies.sum
  end

  def parse_input(input)
    cards = {} of Int32 => NamedTuple(winning: Set(Int32), numbers: Set(Int32))
    input.split('\n').each do |card_str|
      id_str, numbs_str = card_str.split(':')
      id = id_str[/\d+/].to_i
      card = {winning: Set(Int32).new, numbers: Set(Int32).new}
      winning_str, numbers_str = numbs_str.split('|')
      winning_str.split(' ', remove_empty: true).each do |win|
        card[:winning] << win.strip.to_i
      end
      numbers_str.split(' ', remove_empty: true).each do |numb|
        card[:numbers] << numb.strip.to_i
      end
      cards[id] = card
    end
    cards
  end
end

stop_if_not_script(__FILE__)
# test_run("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
# Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
# Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
# Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
# Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
run(__FILE__)
