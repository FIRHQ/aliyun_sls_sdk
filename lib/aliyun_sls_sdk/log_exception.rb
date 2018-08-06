
module AliyunSlsSdk
  class LogException < StandardError
    attr_accessor :errorCode, :errorMessage, :requestId
    def initialize(errorCode, errorMessage, requestId)
      @errorCode = errorCode
      @errorMessage = errorMessage
      @requestId = requestId
    end

    def to_s()
      "LogException: \n{\n    ErrorCode: #{@errorCode}\n    ErrorMessage: #{@errorMessage}\n    RequestId: #{@requestId}\n}\n"
    end
  end
end