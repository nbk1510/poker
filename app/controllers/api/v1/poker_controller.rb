module Api
  module V1
    class CardsController < ApplicationController
      skip_forgery_protection  

      def check
        output = PokerHand::Analyzer.new(params["cards"]).analyze

        respond_to do |format|
          format.json { render json: output.to_json }
        end
      end
    end
  end
end
