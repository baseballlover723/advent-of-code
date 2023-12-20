require "./base"

def solve(arg)
  hands = parse_input(arg)
  # puts "hands: #{hands}"

  hands = sort_hands(hands)
  # hands.each_with_index do |hand, i|
  #   puts "#{i + 1}: #{hand}"
  # end
  # puts "hands: #{hands}"

  sum = 0
  hands.each_with_index do |(hand_str, bid, hand_cards, rank), i|
    sum += (i+1) * bid
  end
  sum
end

def sort_hands(hands)
  hands.sort_by do |hand_str, bid, hand_cards, rank|
    # puts "hand_str: #{hand_str}, rank: #{rank}, hand_cards: #{hand_cards}"
    [rank, hand_cards]
  end#.reverse
end

def parse_input(input)
  hands = input.split("\n").map {|str| str.split(' ')}.map do |hand_str, bid_str|
    cards = hand_str.chars.map {|card| convert_card(card)}
    rank = calc_rank(cards)
    [hand_str, bid_str.to_i, cards, rank]
  end

  hands
end

def calc_rank(cards)
  count = cards.tally.sort_by {|card, count| -count}
  # puts "count: #{count}"
  case count.size
  when 5
    [0, :high_card]
  when 4
    [1, :pair]
  when 3
    # 3 of a kind, 2 pair
    count[0][1] == 2 ? [2, :two_pair] : [3, :three_of_a_kind]
  when 2
    # 4 of a kind, full house
    count[0][1] == 3 ? [4, :full_house] : [5, :four_of_a_kind]
  when 1
    # 5 of a kind
    [6, :five_of_a_kind]
  end

end

def convert_card(card)
  int = card.to_i
  return int if int != 0
  case card
  when 'T'
    10
  when 'J'
    11
  when 'Q'
    12
  when 'K'
    13
  when 'A'
    14
  end
end

return if __FILE__ != $0
# test_run("32T3K 765
# T55J5 684
# KK677 28
# KTJJT 220
# QQQJA 483")
run(__FILE__)
