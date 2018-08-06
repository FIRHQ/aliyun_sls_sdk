module AliyunSlsSdk
  class GetLogRequest < LogRequest
    attr_accessor :project, :logstore, :fromTime, :toTime, :topic, :query, :line, :offset, :reverse
    def initialize(project=nil, logstore=nil, fromTime=nil, toTime=nil, topic=nil, 
                query=nil, line=nil, offset=nil, reverse=nil)
      @project = project
      @logstore = logstore
      @fromTime = fromTime
      @toTime = toTime
      @topic = topic
      @query = query
      @line = line
      @offset = offset
      @reverse = reverse

    end
  end
end