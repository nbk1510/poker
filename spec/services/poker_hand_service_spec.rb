# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PokerHandService do
  describe '.analyze' do
    context 'Invalid cases' do
      context 'Invalid amount of cards' do
        let(:hands_data) { ['C7 C6 C5 C4'] }

        it 'Return correct error message' do
          output = PokerHandService::Analyzer.new(hands_data).analyze
          expect(output['error'].first['msg']).to eq 'The number of cards must be 5. '
        end
      end

      context 'Invalid card format' do
        let(:hands_data) { ['XX C6 C5 C4 C3'] }

        it 'Return correct error message' do
          output = PokerHandService::Analyzer.new(hands_data).analyze
          expect(output['error'].first['msg']).to eq 'The 1st card is invalid (XX). '
        end
      end
    end

    context 'Check business logic' do
      shared_examples 'returns correct poker hand' do |hands_data:, expected_hand:|
        it do
          output = PokerHandService::Analyzer.new(hands_data).analyze
          expect(output['result'].first['hand']).to eq expected_hand
        end
      end

      context 'Straight flush hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['C7 C6 C5 C4 C3'], expected_hand: 'Straight flush'
      end

      context 'Four of a kind hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['C10 D10 H10 S10 D5'], expected_hand: 'Four of a kind'
      end

      context 'Full house hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['S10 H10 D10 S4 D4'], expected_hand: 'Full house'
      end

      context 'Flush hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['H1 H12 H10 H5 H3'], expected_hand: 'Flush'
      end

      context 'Straight hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['S8 S7 H6 H5 S4'], expected_hand: 'Straight'
      end

      context 'Three of a kind hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['S12 C12 D12 S5 C3'], expected_hand: 'Three of a kind'
      end

      context 'Two pair hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['H13 D13 C2 D2 H11'], expected_hand: 'Two pair'
      end

      context 'One pair hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['C10 S10 S6 H4 H2'], expected_hand: 'One pair'
      end

      context 'High card hand' do
        it_behaves_like 'returns correct poker hand', hands_data: ['D1 D10 S9 C5 C4'], expected_hand: 'High card'
      end
    end

    context 'Check with multiple hands' do
      let(:hands_data) { ['H9 H13 H12 H11 H10', 'H9 C9 S9 H2 C2', 'C13 D12 C11 H8 X7'] }

      it "show correct result and set 'best' flag for the correct hand" do
        output = PokerHandService::Analyzer.new(hands_data).analyze
        expect(output['result'].count).to eq 2
        expect(output['result'].first['best']).to eq true
        expect(output['result'].first['hand']).to eq 'Straight flush'
        expect(output['result'].second['hand']).to eq 'Full house'

        expect(output['error'].count).to eq 1
      end
    end
  end
end
