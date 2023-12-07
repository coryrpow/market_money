class Api::V0::MarketVendorsController < ApplicationController

  def create
    market = params[:market_id]
    vendor = params[:vendor_id]

    market_vendor = MarketVendor.new({ market_id: market, vendor_id: vendor })
    # render json: VendorSerializer.new(vendor)
    if market_vendor.save
      render json: MarketVendorSerializer.new(market_vendor), status: :created
    else
      render json: { errors: market_vendor.errors}, status: :not_found
    end
  end

  private

 
end
