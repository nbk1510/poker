require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    it "renders the index page" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "POST /check" do
    let(:params) { 
      {
        "hand": "H9 H13 H12 H11 H10"
      }
    }
    it "renders the index page" do
      post "check", params: params

      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      expected_result = {"result"=>[{"card"=>"H9 H13 H12 H11 H10", "hand"=>"Straight flush", "best"=>true, "value"=>9}], "error"=>[]}
      expect(controller.view_assigns["poker_result"]).to eq expected_result
    end
  end
end