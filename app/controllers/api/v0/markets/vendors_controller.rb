class Api::V0::Markets::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def index
    # require 'pry';binding.pry
    market= Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message)), status: :not_found
  end
end