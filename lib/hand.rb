# Parser to decode hand and find the rank. It can also compare one hand with other
# frozen_string_literal: true
class Hand
  include Comparable

  attr_reader :cards

  def initialize(array_of_cards)
    raise ArgumentError, 'There must be 5 cards' unless array_of_cards.count == 5
    card_hashes =
      array_of_cards.map do |card_string|
        CardParser.new.parse(card_string)
      end
    @cards = card_hashes.map do |card_hash|
      Card.new(card_hash.fetch(:value), card_hash.fetch(:suit))
    end
  end

  def <=>(other_hand)
    rank_type = POKER_RANKS.index(rank.fetch(:type))
    other_hand_rank_type = POKER_RANKS.index(other_hand.rank.fetch(:type))
    if rank_type == other_hand_rank_type
      compare_value(:value, rank, other_hand.rank) ||
        compare_value(:full_of, rank, other_hand.rank) ||
        compare_card_arrays(:pairs, rank, other_hand.rank) ||
        compare_card_arrays(:cards, rank, other_hand.rank) ||
        0
    else
      rank_type <=> other_hand_rank_type
    end
  end

  POKER_RANKS = [
    :highest,
    :pair,
    :two_pair,
    :three_of_a_kind,
    :straight,
    :flush,
    :full_house,
    :four_of_a_kind,
    :straight_flush
  ].freeze

  def rank
    straight_flush ||
      four_of_a_kind ||
      full_house ||
      flush ||
      straight ||
      three_of_a_kind ||
      two_pair ||
      pair ||
      highest
  end

  private

  def straight_flush
    straight.merge(type: :straight_flush) if flush && straight
  end

  def four_of_a_kind
    if values_per_occurence[4]
      {
        type: :four_of_a_kind,
        value: values_per_occurence[4].first,
        cards: values_per_occurence[1]
      }
    end
  end

  def full_house
    if values_per_occurence[3] && values_per_occurence[2]
      {
        type: :full_house,
        value: values_per_occurence[3].first,
        full_of: values_per_occurence[2].first
      }
    end
  end

  def flush
    if suits_per_occurence[5]
      {
        type: :flush,
        cards: values_per_occurence[1]
      }
    end
  end

  def straight
    card_values = cards.map(&:value)
    aces_as_ones = aces_as_ones(card_values)
    if aces_as_ones != card_values && consecutive_cards?(aces_as_ones)
      { type: :straight, value: 5 }
    elsif consecutive_cards?(card_values)
      { type: :straight, value: high_card }
    end
  end

  def three_of_a_kind
    if values_per_occurence[3]
      {
        type: :three_of_a_kind,
        value: values_per_occurence[3].first,
        cards: values_per_occurence[1]
      }
    end
  end

  def two_pair
    if values_per_occurence[2] && values_per_occurence[2].size == 2
      {
        type: :two_pair,
        pairs: values_per_occurence[2],
        cards: values_per_occurence[1]
      }
    end
  end

  def pair
    if values_per_occurence[2]
      {
        type: :pair,
        value: values_per_occurence[2].first,
        cards: values_per_occurence[1]
      }
    end
  end

  def highest
    {
      type: :highest,
      cards: values_per_occurence[1]
    }
  end

  def values_per_occurence
    result = results_per_occurence_number(cards.map(&:value))
    result.each do |nb_occurence, values|
      result[nb_occurence] = values.sort.reverse
    end
    result
  end

  def suits_per_occurence
    results_per_occurence_number(cards.map(&:suit))
  end

  def compare_card_arrays(key, rank, other_rank)
    if rank.key?(key)
      cards = rank.fetch(key)
      other_cards = other_rank.fetch(key)
      if cards != other_cards
        (cards - other_cards).max <=> (other_cards - cards).max
      end
    end
  end

  def compare_value(key, rank, other_rank)
    if rank.key?(key)
      if rank.fetch(key) != other_rank.fetch(key)
        rank.fetch(key) <=> other_rank.fetch(key)
      end
    end
  end

  def consecutive_cards?(card_values)
    array_consecutive_integers?(card_values)
  end

  def aces_as_ones(card_values)
    number_aces = card_values.select { |i| i == 14 }.count
    result = card_values.clone
    if number_aces >= 1
      result.delete(14)
      number_aces.times do
        result << 1
      end
    end
    result
  end

  def high_card
    cards.map(&:value).max
  end

  def results_per_occurence_number(array)
    grouped_values = array.group_by { |i| i }
    result = {}
    grouped_values.each do |key, value|
      if result[value.count]
        result[value.count] << key
      else
        result[value.count] = [key]
      end
    end
    result
  end

  def array_consecutive_integers?(array)
    array.sort!
    difference_always_1 = true
    i = 0
    while difference_always_1 && i < (array.size - 1)
      difference_between_values = array[i + 1] - array[i]
      difference_always_1 = difference_between_values == 1
      i += 1
    end
    difference_always_1
  end
end
