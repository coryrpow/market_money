class Api::V0::VendorsController < ApplicationController

  def show
    # require 'pry';binding.pry
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    @vendor = Vendor.new(vendor_params)
        @vendor.save!
        render json: VendorSerializer.new(@vendor), status: :created
    # require 'pry';binding.pry
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update!(vendor_params)
    render json: VendorSerializer.new(vendor)
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy
  end

  # def create
  #   @vendor = Vendor.new(vendor_params)
  #   if @vendor.save
  #     render json: VendorSerializer.new(@vendor), status: :created
  #   else
  #     render json: ErrorSerializer.new(ErrorMessage.new(@vendor.errors.full_messages.join(', '))), status: :bad_request
  #   end
  #   # require 'pry';binding.pry
  # end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end