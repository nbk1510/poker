require 'rails_helper'

RSpec.describe "/api", type: :request do
  
  describe "POST /api/v1/analyze" do
    context "params with valid poker hands" do
      let(:params) { 
        {
          "cards": [
            "H9 H13 H12 H11 H10",
            "H9 C9 S9 H2 C2",
            "C13 D12 C11 H8 H7"
          ]
        }
      }
      it "renders a successful response with correct data" do
        headers = { "ACCEPT" => "application/json" }
        post "/api/v1/cards/check", params: params, :headers => headers

        expected_result = {
          "result" => [
            {"card" => "H9 H13 H12 H11 H10", "hand" => "Straight flush", "best" => true, "value" => 9},
            {"card" => "H9 C9 S9 H2 C2", "hand" => "Full house", "best" => false, "value" => 7},
            {"card" => "C13 D12 C11 H8 H7", "hand" => "High card", "best" => false, "value" => 1}],
          "error"=>[]
        }
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq expected_result
      end
    end
    
    context "params with invalid data" do
      let(:params) { 
        {
          "cards": [
            "H9 H13 H12 H11 H10",
            "H9 C9 S9 X2 C2",
            "C13 D12"
          ]
        }
      }
      it "renders a successful response with correct data" do
        headers = { "ACCEPT" => "application/json" }
        post "/api/v1/cards/check", params: params, :headers => headers

        expected_result = {
          "result" => [
            {"card" => "H9 H13 H12 H11 H10", "hand" => "Straight flush", "best" => true, "value" => 9}
          ],
          "error" => [
            {"card" => "H9 C9 S9 X2 C2", "msg" => "The 4th card is invalid (X2). "},
            {"card" => "C13 D12", "msg" => "The number of cards must be 5. "}
          ]
        }
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq expected_result
      end
    end
  end
end
