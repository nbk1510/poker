# frozen_string_literal: true

module PokerHandService
  class Card
    VALID_SUITS = {
      'C' => 0,
      'D' => 1,
      'H' => 2,
      'S' => 3
    }.freeze

    attr_accessor :card

    def initialize(card)
      # card input is string, example: H13
      @card = card
    end

    def suit
      @card.first.upcase
    end

    def number
      @card[1..].to_i
    end

    def valid?
      return false unless VALID_SUITS.keys.include?(suit)
      return false unless number.is_a?(Integer)
      return false if number.to_i <= 0 || number.to_i > 13

      true
    end
  end

  class Analyzer
    VALUE_OF_HANDS_MAPPING = {
      9 => 'Straight flush',
      8 => 'Four of a kind',
      7 => 'Full house',
      6 => 'Flush',
      5 => 'Straight',
      4 => 'Three of a kind',
      3 => 'Two pair',
      2 => 'One pair',
      1 => 'High card'
    }.freeze

    def initialize(hands_data = [])
      @hands_data = hands_data
      @hands = ''
    end

    # 1 straight flush	Consists of 5 cards of the same suit with consecutive numbers	C7 C6 C5 C4 C3, H1 H13 H12 H11 H10
    # 2	Four of a Kind	Contains four cards with the same number	C10 D10 H10 S10 D5, D5 D6 H6 S6 C6
    # 3	full house    	Consists of 3 cards with the same number and 2 cards with another same number	S10 H10 D10 S4 D4, H9 C9 S9 H1 C1
    # 4	flush	          Consists of 5 cards of the same suit	H1 H12 H10 H5 H3, S13 S12 S11 S9 S6
    # 5	straight	      Composed of 5 cards with consecutive numbers	S8 S7 H6 H5 S4, D6 S5 D4 H3 C2
    # 6	Three of a kind	Consists of three cards with the same number and two cards with different numbers	S12 C12 D12 S5 C3, C5 H5 D5 D12 C10
    # 7	two pair	      Consists of two sets of two cards of the same number and one other card	H13 D13 C2 D2 H11, D11 S11 S10 C10 S9
    # 8	one pair	      Consists of 1 sets of 2 cards of the same number and 3 cards of different numbers each	C10 S10 S6 H4 H2, H9 C9 H1 D12 D10
    # 9	high card	      None of the above

    def analyze
      result = []
      errors = []
      output_data = {
        'result' => result,
        'error' => errors
      }
      @hands_data.each do |hand|
        cards = hand.split(' ').map { |card| Card.new(card) }
        errors = validate_hand(cards, hand)
        if errors.present?
          output_data['error'] << errors
        else
          poker_hand = check_for_hand(cards)
          hand_value = VALUE_OF_HANDS_MAPPING.key(poker_hand)
          data = {
            'card' => hand,
            'hand' => poker_hand,
            'best' => false,
            'value' => hand_value
          }
          output_data['result'] << data
        end
      end

      if output_data['result'].present?
        best_hand = output_data['result'].detect do |result|
          result['card'] == output_data['result'].max_by { |e| e['value'] }['card']
        end
        best_hand['best'] = true
        output_data['result'] = output_data['result'].map { |e| e.except('value') }
      end

      # hands_with_poker_data = @hands_data.map{|e|  }
      output_data
    end

    private

    def validate_hand(cards, hand)
      errors = {}
      msg = ''
      msg << 'The number of cards must be 5. ' if cards.count != 5
      cards.each_with_index do |card, i|
        msg << "The #{(i + 1).ordinalize} card is invalid (#{card.card}). " unless card.valid?
      end
      if msg.present?
        errors['card'] = hand
        errors['msg'] = msg
      end
      errors
    end

    def check_for_hand(cards)
      number_sorted_cards = cards.sort_by { |c| [c.number] }
      suit_sorted_cards = cards.sort_by { |c| [c.number, c.suit] }
      has_straight = five_consecutive_number?(number_sorted_cards)
      has_flush = five_same_suit?(suit_sorted_cards)

      tally_h = number_sorted_cards.map(&:number).tally

      pair_count = tally_h.values.count(2)
      three_of_kind_count = tally_h.values.count(3)
      four_of_kind_count = tally_h.values.count(4)

      if has_straight && has_flush
        VALUE_OF_HANDS_MAPPING[9]
      elsif four_of_kind_count == 1
        VALUE_OF_HANDS_MAPPING[8]
      elsif three_of_kind_count == 1 && pair_count == 1
        VALUE_OF_HANDS_MAPPING[7]
      elsif has_flush
        VALUE_OF_HANDS_MAPPING[6]
      elsif has_straight
        VALUE_OF_HANDS_MAPPING[5]
      elsif three_of_kind_count == 1
        VALUE_OF_HANDS_MAPPING[4]
      elsif pair_count == 2
        VALUE_OF_HANDS_MAPPING[3]
      elsif pair_count == 1
        VALUE_OF_HANDS_MAPPING[2]
      else
        VALUE_OF_HANDS_MAPPING[1]
      end
    end

    def five_consecutive_number?(number_sorted_cards)
      # special case for ace-high straight flush
      return true if number_sorted_cards.map(&:number) == [1, 10, 11, 12, 13]

      result_flag = true
      checking_card = number_sorted_cards.first

      number_sorted_cards.drop(1).each do |card|
        if card.number == (checking_card.number + 1)
          checking_card = card
        else
          result_flag = false
          break
        end
      end
      result_flag
    end

    def five_same_suit?(suit_sorted_cards)
      result_flag = true
      checking_card = suit_sorted_cards.first

      suit_sorted_cards.drop(1).each do |card|
        if card.suit == checking_card.suit
          checking_card = card
        else
          result_flag = false
          break
        end
      end
      result_flag
    end
  end
end
