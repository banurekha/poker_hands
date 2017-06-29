# frozen_string_literal: true
require 'spec_helper'
require 'card_parser'

describe CardParser do
  let(:single_digit_card_string) { '6H' }
  let(:two_digit_card_string) { 'TS' }
  let(:jack_card_string) { 'JH' }
  let(:queen_card_string) { 'QD' }
  let(:king_card_string) { 'KC' }
  let(:ace_card_string) { 'AH' }
  let(:ace_as_one_card_string) { '1D' }

  it 'parses a card string with a single digit number' do
    parsed_card = described_class.new.parse(single_digit_card_string)
    expect(parsed_card.fetch(:suit)).to eq :hearts
    expect(parsed_card.fetch(:value)).to eq 6
  end

  it 'parses a card string with a two digit number' do
    parsed_card = described_class.new.parse(two_digit_card_string)
    expect(parsed_card.fetch(:suit)).to eq :spades
    expect(parsed_card.fetch(:value)).to eq 10
  end

  it 'parses a jack card string' do
    parsed_card = described_class.new.parse(jack_card_string)
    expect(parsed_card.fetch(:suit)).to eq :hearts
    expect(parsed_card.fetch(:value)).to eq 11
  end

  it 'parses a queen card string' do
    parsed_card = described_class.new.parse(queen_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:value)).to eq 12
  end

  it 'parses a king card string' do
    parsed_card = described_class.new.parse(king_card_string)
    expect(parsed_card.fetch(:suit)).to eq :clubs
    expect(parsed_card.fetch(:value)).to eq 13
  end

  it 'parses an ace card string' do
    parsed_card = described_class.new.parse(ace_card_string)
    expect(parsed_card.fetch(:suit)).to eq :hearts
    expect(parsed_card.fetch(:value)).to eq 14
  end

  it 'parses an ace card string when it is written as a 1' do
    parsed_card = described_class.new.parse(ace_as_one_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:value)).to eq 14
  end

  it 'fails if the card string does not have a recognised suit' do
    expect { described_class.new.parse('5Z') }.to raise_error(ArgumentError)
  end

  it 'fails if the wrong capitalisation is used for the suit' do
    expect { described_class.new.parse('5s') }.to raise_error(ArgumentError)
  end

  it 'fails if the wrong capitalisation is used for the values' do
    expect { described_class.new.parse('qD') }.to raise_error(ArgumentError)
  end
end
