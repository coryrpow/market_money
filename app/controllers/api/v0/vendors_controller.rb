class Api::V0::VendorsController < ApplicationController
  def index
    # require 'pry';binding.pry
    market= Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end
end