class HomeController < ApplicationController
  def index
  end

  def check
    @poker_result = PokerHandService::Analyzer.new([params[:hand]]).analyze
    render "index"
  end
end
