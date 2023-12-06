class ErrorSerializer
  def initialize(errors)
    @errors = errors
  end

  def serialize_json
    {
       errors: [
           {
               detail: @errors.detail
           }
       ]
      }.to_json
  end
end