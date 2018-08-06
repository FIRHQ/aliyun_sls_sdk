module AliyunSlsSdk
  class LogResponse
    attr_accessor :request_id,:all_headers

    def initialize(headers)
      @all_headers = headers
      if headers['x-log-requestid']
        @request_id = headers['x-log-requestid']
      end
        @request_id = ''
    end

    def get_header(key)
      return @all_headers[key]
    end
  end
end
