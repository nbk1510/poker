class HomeController < ApplicationController
  def index
  end

  def check
    @poker_result = PokerHand::Analyzer.new([params[:hand]]).analyze
    render "index"
  end
end
