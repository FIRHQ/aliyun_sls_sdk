require "time"

module AliyunSlsSdk
  class LogItem

    attr_accessor :timestamp, :contents
    # contents is a hash
    def initialize(timestamp, contents)
      if not timestamp
        @timestamp = Time.now.to_i
      end
      @contents = contents
    end
  end

end
