class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def show
    # require 'pry';binding.pry
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    @vendor = Vendor.new(vendor_params)
      begin 
        @vendor.save!
        render json: VendorSerializer.new(@vendor), status: :created
      rescue ActiveRecord::RecordInvalid => e
        error_messages = e.record.errors.full_messages.join(', ')
        render json: { errors: [{ status: "400", detail: "Validation failed: #{error_messages}" }] }, status: :bad_request
      end
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

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message)), status: :not_found
  end

  # def bad_request_reponse(exception)
  #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message)), status: :bad_request
  # end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end