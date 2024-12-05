# frozen_string_literal: true

module Api
  module V1
    class CardsController < ApplicationController
      skip_forgery_protection

      def check
        unless cards_params.is_a?(Array)
          respond_to do |format|
            format.json { render json: { message: 'Invalid input format.' }, status: 422 }
          end and return
        end

        output = PokerHandService::Analyzer.new(params['cards']).analyze

        respond_to do |format|
          format.json { render json: output.to_json }
        end
      end

      private

      def cards_params
        params.require(:cards)
      end
    end
  end
end
