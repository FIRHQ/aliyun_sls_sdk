require 'json'

module AliyunSlsSdk
  class CreateLogStoreResponse < LogResponse

    def initialize(header)
      super(header)
    end

    def log_print()
      puts 'CreateLogStoreResponse:'
      puts 'headers:' + self.all_headers.to_json
    end
  end
end