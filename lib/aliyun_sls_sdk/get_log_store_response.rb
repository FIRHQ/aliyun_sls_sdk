module AliyunSlsSdk
  class GetLogStoreResponse < LogResponse

    attr_accessor :ttl, :shard_count, :logstore_name
    def initialize(resp, header)
      super(header)
      puts resp
      @logstore_name = resp["logstoreName"]
      @ttl = resp["ttl"] ? resp["ttl"].to_i : 0
      @shard_count = resp["shardCount"] ? resp["shardCount"].to_i : 0
    end
  end
end