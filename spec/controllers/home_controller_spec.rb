# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET index' do
    before { get :index }

    it 'renders the index page' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'POST /check' do
    let(:params) do
      {
        "hand": 'H1 H13 H12 H11 H10'
      }
    end

    let(:expected_result) do
      { 'result' => [{ 'card' => 'H1 H13 H12 H11 H10', 'hand' => 'Straight flush', 'best' => true }], 'error' => [] }
    end

    before { post 'check', params: params }

    it 'renders the index page' do
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      expect(controller.view_assigns['poker_result']).to eq expected_result
    end
  end
end
