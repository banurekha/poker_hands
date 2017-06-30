# Parser to decode 2 character string into valid value and suit
# frozen_string_literal: true
class CardParser
  def parse(card_string)
    end_of_card_number_index = card_string.length - 2
    value_string = card_string[0..end_of_card_number_index]
    suit_string = card_string[end_of_card_number_index + 1]
    {
      value: value_lookup(value_string),
      suit: suit_lookup(suit_string)
    }
  end

  private

  SUITS = {
    'H' => :hearts,
    'D' => :diamonds,
    'S' => :spades,
    'C' => :clubs
  }.freeze

  VALUES = {
    '1' => 14,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    'T' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }.freeze

  def value_lookup(value_string)
    VALUES.fetch(value_string)
  rescue KeyError
    raise ArgumentError, "Error: #{value_string} not recognised as valid Value"
  end

  def suit_lookup(suit_string)
    SUITS.fetch(suit_string)
  rescue KeyError
    raise ArgumentError, "Error: #{suit_string} not recognised as valid Suit"
  end
end
