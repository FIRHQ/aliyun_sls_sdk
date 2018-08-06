
module AliyunSlsSdk
  class PutLogsRequest < LogRequest
    attr_accessor :project, :logstore, :topic, :source, :logitems, :hashkey, :compress
    def initialize(project=nil, logstore=nil, topic=nil, source=nil, logitems=nil, hashKey = nil, compress = false)
      @project = project
      @logstore = logstore
      @topic = topic
      @source = source
      @logitems = logitems
      @hashkey = hashKey
      @compress = compress
    end
  end
end