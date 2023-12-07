class ErrorSerializer
  def initialize(errors)
    @error_object = errors
  end

  def serialize_json
    # {
    #    errors: [
    #        {
    #            status: @error_object.status_code.to_s,
    #            detail: @error_object.message
    #        }
    #    ]
    #   }
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