# frozen_string_literal: true
require 'spec_helper'
require 'hand'
require 'card_parser'
require 'card'

describe Hand do
  let(:card_parser) { CardParser.new }
  let(:pair_hand_string_array) { %w(5H 5D 6D 7D 8D) }
  let(:hand_string_array) { pair_hand_string_array }
  let(:other_hand_string_array) { pair_hand_string_array }
  let(:hand) { described_class.new(hand_string_array) }
  let(:other_hand) { described_class.new(other_hand_string_array) }

  describe 'hand comparisons' do
    it 'tells me if the hand is better' do
      four_of_a_kind_hand = described_class.new(%w(5H 5D 5S 5C 8D))
      full_house_hand = described_class.new(%w(5H 5D 5S 6C 6H))
      expect(four_of_a_kind_hand).to be > full_house_hand
    end
  end

  describe '#rank' do
    context 'pair hand' do
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :pair
      end
      it 'returns the value correctly' do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it 'returns the other cards correctly' do
        expect(hand.rank.fetch(:cards)).to eq [8, 7, 6]
      end
      context 'comparison' do
        context 'with a hand with a lower pair' do
          let(:other_hand_string_array) { %w(4H 4D 6S 7S 8S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same pair but lower cards' do
          let(:other_hand_string_array) { %w(5S 5C 2D 7S 8S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same pair and same values for other cards' do
          let(:other_hand_string_array) { %w(5S 5C 6S 7S 8S) }
          it 'is a tie' do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context 'high card' do
      let(:hand_string_array) { %w(4H 5D 6D 7D 9D) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :highest
      end
      it 'returns the other cards correctly' do
        expect(hand.rank.fetch(:cards)).to eq [9, 7, 6, 5, 4]
      end
      context 'comparison' do
        context 'with a hand with lower cards' do
          let(:other_hand_string_array) { %w(4S 5C 2D 3S 9S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
      end
    end

    context 'three of a kind' do
      let(:hand_string_array) { %w(5H 5D 5S 7D 8D) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :three_of_a_kind
      end
      it 'returns the value correctly' do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it 'returns the other cards correctly' do
        expect(hand.rank.fetch(:cards)).to eq [8, 7]
      end
      context 'comparison' do
        context 'with a hand with the same three of a kind but lower cards' do
          let(:other_hand_string_array) { %w(5H 5D 5S 7S 6S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same three of a kind and same values for other cards' do
          let(:other_hand_string_array) { %w(5H 5D 5S 7S 8S) }
          it 'is a tie' do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context 'four of a kind' do
      let(:hand_string_array) { %w(5H 5D 5S 5C 8D) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :four_of_a_kind
      end
      it 'sets the value correctly' do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it 'sets the rank correctly' do
        expect(hand.rank.fetch(:cards).first).to eq 8
      end
      context 'comparison' do
        context 'with a hand with the same four of a kind but lower cards' do
          let(:other_hand_string_array) { %w(5H 5D 5D 5C 6S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same four of a kind and same values for other cards' do
          let(:other_hand_string_array) { %w(5H 5D 5S 5C 8H)  }
          it 'is a tie' do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context 'full house' do
      let(:hand_string_array) { %w(5H 5D 5S 6C 6H) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :full_house
      end
      it 'returns the highest correctly' do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it 'returns the full_of value correctly' do
        expect(hand.rank.fetch(:full_of)).to eq 6
      end
      context 'comparison' do
        context 'with a hand with a smaller highest' do
          let(:other_hand_string_array) { %w(4H 4D 4S 6C 6H) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same highest but lower filler' do
          let(:other_hand_string_array) { %w(5H 5D 5S 4C 4H) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same highest and same filler' do
          let(:other_hand_string_array) { %w(5H 5D 5S 6S 6D) }
          it 'is a tie' do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context 'flush hand' do
      let(:hand_string_array) { %w(5H 6H 7H 8H TH) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :flush
      end
      it 'returns the other cards correctly' do
        expect(hand.rank.fetch(:cards)).to eq [10, 8, 7, 6, 5]
      end
      context 'comparison' do
        context 'with a hand with lower cards' do
          let(:other_hand_string_array) { %w(5H 2H 7H 8H TH) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
      end
    end

    context 'straight hand' do
      let(:hand_string_array) { %w(5H 6H 7H 8H 9D) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it 'sets the highest hand correctly' do
        expect(hand.rank.fetch(:value)).to eq 9
      end
      context 'comparison' do
        context 'with a hand with a lower higher card' do
          let(:other_hand_string_array) { %w(5H 6H 7H 8H 2C) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
      end
    end

    context 'straight with low ace hand' do
      let(:hand_string_array) { %w(2H 3H 4H 5H AD) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it 'sets the highest hand correctly' do
        expect(hand.rank.fetch(:value)).to eq 5
      end
    end

    context 'straight with high ace hand' do
      let(:hand_string_array) { %w(TH JH QH KH AD) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it 'sets the highest hand correctly' do
        expect(hand.rank.fetch(:value)).to eq 14
      end
    end

    context 'two pairs' do
      let(:hand_string_array) { %w(5C 5S 7D 7H 9S) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :two_pair
      end
      it 'sets the pairs correctly' do
        expect(hand.rank.fetch(:pairs)).to eq [7, 5]
      end
      it 'sets the rank correctly' do
        expect(hand.rank.fetch(:cards).first).to eq 9
      end
      context 'comparison' do
        context 'with a hand with no identical pairs, best pair lower, same rank' do
          let(:other_hand_string_array) { %w(5H 5D 6D 6H 9S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with lower high pair, sane lower pair, same rank' do
          let(:other_hand_string_array) { %w(4H 4D 6D 6H 9S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with high identical pair, one lower pair, same rank' do
          let(:other_hand_string_array) { %w(3H 3D 7D 7H 9S) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
        context 'with a hand with the same two pairs and same values on rank' do
          let(:other_hand_string_array) { %w(5H 5D 7D 7S 9D) }
          it 'is a tie' do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context 'two pairs with low rank' do
      let(:hand_string_array) { %w(4H 4D 6D 6H 2S) }
      it 'sets the rank correctly' do
        expect(hand.rank.fetch(:cards).first).to eq 2
      end
    end

    context 'straight flush' do
      let(:hand_string_array) { %w(5S 6S 7S 8S 9S) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
      it 'sets the highest hand correctly' do
        expect(hand.rank.fetch(:value)).to eq 9
      end
      context 'Compare Hands' do
        context 'with a hand with a lower higher card' do
          let(:other_hand_string_array) { %w(5H 6H 7H 8H 4H) }
          it 'is better' do
            expect(hand).to be > other_hand
          end
        end
      end
    end

    context 'straight flush with low ace hand' do
      let(:hand_string_array) { %w(2D 3D 4D 5D AD) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
      it 'sets the highest hand correctly' do
        expect(hand.rank.fetch(:value)).to eq 5
      end
    end

    context 'straight flush with high ace hand' do
      let(:hand_string_array) { %w(TC JC QC KC AC) }
      it 'ranks the hand correctly' do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
      it 'sets the highest hand correctly' do
        expect(hand.rank.fetch(:value)).to eq 14
      end
    end
  end
end
