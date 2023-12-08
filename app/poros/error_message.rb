class ErrorMessage
  attr_reader :message, :status_code

  def initialize(message, status_code)
    @message = message
    @status_code = status_code
  end

  def self.market_vendor_status(exception)
    if exception.message.include?("must exist")
      404
    else
      422
    end
  end
end