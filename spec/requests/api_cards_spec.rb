# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/cards', type: :request do
  describe 'POST /api/v1/cards/check' do
    context 'params with valid poker hands' do
      let(:params) do
        {
          "cards": [
            'H1 H13 H12 H11 H10',
            'H9 C9 S9 H2 C2',
            'C13 D12 C11 H8 H7'
          ]
        }
      end
      let(:headers) { { 'ACCEPT' => 'application/json' } }
      let(:expected_result) do
        {
          'result' => [
            { 'card' => 'H1 H13 H12 H11 H10', 'hand' => 'Straight flush', 'best' => true },
            { 'card' => 'H9 C9 S9 H2 C2', 'hand' => 'Full house', 'best' => false },
            { 'card' => 'C13 D12 C11 H8 H7', 'hand' => 'High card', 'best' => false }
          ],
          'error' => []
        }
      end
      before { post '/api/v1/cards/check', params: params, headers: headers }

      it 'renders a successful response with correct data' do
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq expected_result
      end
    end

    context 'params with invalid data' do
      let(:params) do
        {
          "cards": [
            'H1 H13 H12 H11 H10',
            'H9 C9 S9 X2 C2',
            'C13 D12'
          ]
        }
      end
      let(:headers) { { 'ACCEPT' => 'application/json' } }
      let(:expected_result) do
        {
          'result' => [
            { 'card' => 'H1 H13 H12 H11 H10', 'hand' => 'Straight flush', 'best' => true }
          ],
          'error' => [
            { 'card' => 'H9 C9 S9 X2 C2', 'msg' => 'The 4th card is invalid (X2). ' },
            { 'card' => 'C13 D12', 'msg' => 'The number of cards must be 5. ' }
          ]
        }
      end

      before { post '/api/v1/cards/check', params: params, headers: headers }

      it 'renders a successful response with correct data' do
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq expected_result
      end
    end
  end
end
