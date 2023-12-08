class ErrorSerializer
  def initialize(errors)
    @error_object = errors
  end

  def serialize_json
    {
        errors: [
          {
            status: @error_object.status_code.to_s,
            detail: @error_object.message
          }

        ]
      }
  end

  def  market_vendor_serialize(errors)
    
  end
  
  def market_vendor_error
    {
        errors: [
          {
            status: @error_object.status_code.to_s,
            detail: @error_object.message
          }

        ]
      }
  end 
end