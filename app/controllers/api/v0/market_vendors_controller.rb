class Api::V0::MarketVendorsController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :market_vendor_not_found
#   def create
#     market = params[:market_id]
#     vendor = params[:vendor_id]
# # require 'pry';binding.pry
#     # unless Vendor.exists?(vendor) && Market.exists?(market)
#     #   raise ActiveRecord::RecordNotFound.new("Validation failed: #{market || vendor} must exist")
#     # end

#     market_vendor = MarketVendor.new({ market_id: market, vendor_id: vendor })
#     market_vendor.save!
#     render json: MarketVendorSerializer.new(market_vendor), status: :created
#   end

  def create
    market = params[:market_id]
    vendor = params[:vendor_id]
    begin
      market_vendor = MarketVendor.create!({ market_id: market, vendor_id: vendor })
      render json: { "message": "Successfully added vendor to market"}, status: :created
    rescue ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, ErrorMessage.market_vendor_status(exception)))
      .market_vendor_error, status: ErrorMessage.market_vendor_status(exception)
    end
  end

  private

end
