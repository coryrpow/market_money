class ErrorMessage
  attr_reader :detail

  def initialize(detail)
    # @message = message
    @detail = detail
  end
end