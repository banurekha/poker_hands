# frozen_string_literal: true
# Execute this script with path to the data file as the first argument.
#
# bundle exec ruby winning_hand.rb /path/to/data/file
# Bonus it does parse wining for player2 as well just not print it

require_relative 'lib/card_parser'
require_relative 'lib/hand_parser'
require_relative 'lib/hand'
require_relative 'lib/card'

data_file = ARGV[0]

first_winning = second_winning = 0

File.new(data_file).each do |line|
  first_player_cards = line.split(/\W/)[0..4]
  second_player_cards = line.split(/\W/)[5..9]
  first_hand = Hand.new(first_player_cards)
  second_hand = Hand.new(second_player_cards)
  if first_hand > second_hand
    first_winning += 1
  else
    second_winning += 1
  end
end
p "Player 1 Winning: #{first_winning}"
