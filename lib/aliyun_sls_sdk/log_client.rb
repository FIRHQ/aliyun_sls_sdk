require "time"
require "addressable/uri"
require "net/http/persistent"
require "json"

module AliyunSlsSdk
  class LogClient

    attr_reader :http

    @@API_VERSION = "0.6.0"
    @@USER_AGENT = "log-ruby-sdk-v-0.6.1"
    def initialize(endpoint, accessKeyId, accessKeySecret, ssl_verify = false)
      @endpoint = endpoint
      @accessKeyId = accessKeyId
      @accessKeySecret = accessKeySecret
      @ssl_verify = ssl_verify
      @http = Net::HTTP::Persistent.new
    end

    def get_logstore(project_name, logstore_name)
      headers = {}
      params = {}
      resource = "/logstores/" + logstore_name
      resp, header = send("GET", project_name, nil, resource, params, headers)
      return GetLogStoreResponse.new(resp, header)
    end


    def create_logstore(project_name, logstore_name, ttl, shard_count)
      headers = {}
      params = {}
      headers["x-log-bodyrawsize"] = '0'
      headers["Content-Type"] = "application/json"
      resource = "/logstores"
      body = {}
      body["logstoreName"] = logstore_name.encode("utf-8");
      body["ttl"] = ttl;
      body["shardCount"] = shard_count;
      body_str = body.to_json;
      resp, header = send("POST", project_name, body_str, resource, params, headers)
      return CreateLogStoreResponse.new(header)
    end


    def get_logs()

    end

    # 这里接受参数
    # (project=nil, logstore=nil, topic=nil, source=nil, logitems=nil, hashKey = nil, compress = false)
    # 其中 logitems = [{timestamp: Time.now.to_i, contents: [['aaa', '111'], ['ccc', 222]]}]
    # 
    def put_logs(request)
      if request.logitems.length > 4096
        raise AliyunSlsSdk::PostBodyTooLarge, "log item is larger than 4096"
      end
      logGroup = Protobuf::LogGroup.new(:logs => [])
      logGroup.topic = request.topic
      logGroup.source = request.source
      request.logitems.each { |logitem|
        # log = Protobuf::Log.new(:time => logitem.timestamp, :contents => [])
        # logGroup.logs << log
        # contents = logitem.contents
        # contents.each { |k, v|
        #   content = Protobuf::Log::Content.new(:key => k, :value => v)
        #   log.contents <<  content
        # }
        log = Protobuf::Log.new(:time => logitem[:timestamp], :contents => [])
        
        contents = logitem[:contents]
        contents.each { |detail|
          content = Protobuf::Log::Content.new(:key => detail[0], :value => detail[1])
          log.contents <<  content
        }
        logGroup.logs << log
         
      }
      body = logGroup.encode.to_s
      if body.length > 3 * 1024 * 1024
        raise AliyunSlsSdk::PostBodyTooLarge, "content length is larger than 3MB"
      end
      headers = {}
      headers['x-log-bodyrawsize'] = body.length.to_s
      headers['Content-Type'] = 'application/x-protobuf'
      is_compress = request.compress

      compress_data = nil
      if is_compress
          headers['x-log-compresstype'] = 'deflate'
          compress_data = Zlib::Deflate.deflate(body)

      end
      params = {}
      logstore = request.logstore
      project = request.project
      resource = '/logstores/' + logstore
      if request.hashkey
          resource = '/logstores/' + logstore+"/shards/route"
          params["key"] = request.hashkey
      else
          resource = '/logstores/' + logstore+"/shards/lb"
      end

      respHeaders = nil
      if is_compress
          respHeaders = send('POST', project, compress_data, resource, params, headers)
      else
          respHeaders = send('POST', project, body, resource, params, headers)
      end
      return PutLogsResponse.new(respHeaders[1])

    end



    private
    def send(method, project, body, resource, params, headers, respons_body_type ='json')
      if body
        headers['Content-Length'] = body.bytesize.to_s
        headers['Content-MD5'] = Util.cal_md5(body)
      else
        headers['Content-Length'] = '0'
        headers["x-log-bodyrawsize"] = '0'
      end
      headers['x-log-apiversion'] = @@API_VERSION
      headers['x-log-signaturemethod'] = 'hmac-sha1'
      scheme = @ssl_verify ? "https" : "http"
      url = "#{scheme}://" + project + "." + @endpoint
      headers['Host'] = project + "." + @endpoint
      headers['Date'] = headers["Date"] = DateTime.now.httpdate
      signature = Util.get_request_authorization(method, resource,
            @accessKeySecret, params, headers)
      headers['Authorization'] = "LOG " + @accessKeyId + ':' + signature
      url = url + resource
      return sendRequest(method, url, params, body, headers, respons_body_type)
    end

    def loadJson(respText, requestId)
      if respText.empty?
        return nil
      else
        begin
          return JSON.parse(respText)
        rescue JSON::ParserError => e
          raise LogException.new("BadResponse", "Bad json format:\n#{respText}", requestId)
        end
      end
    end

    def sendRequest(method, url, params, body, headers, respons_body_type = 'json')
      statusCode, respBody, respHeaders = getHttpResponse(method, url, params, body, headers)
      if respHeaders['x-log-requestid']
        requestId = respHeaders['x-log-requestid']
      else
        requestId = ''
      end

      if statusCode == '200'
        if respons_body_type == 'json'
          return loadJson(respBody, requestId), respHeaders
        else
          return respBody, respHeaders
        end
      end
      respJson = loadJson(respBody, requestId)
      if respJson["errorCode"] and respJson["errorMessage"]
        raise LogException.new(respJson["errorCode"], respJson["errorMessage"], requestId)
      else
        exStr = ""
        if respBody
          exStr = ". Return Json is #{respBody}"
        else
          exStr = "."
        end
        raise LogException.new("LogRequestError", "Request is failed. Http code is #{statusCode} #{exStr}", requestId)
      end
    end

    def getHttpResponse(method, url, params, body, headers)
      headers['User-Agent'] = @@USER_AGENT
      r = nil
      uri = Addressable::URI.parse(url)
      uri.query_values = params
      methodRequest = nil
      if method.downcase == 'get'
        methodRequest = Net::HTTP::Get.new(uri.request_uri, headers)
      elsif method.downcase == 'post'
        methodRequest = Net::HTTP::Post.new(uri.request_uri, headers)
        methodRequest.body = body
      end
      response = @http.request uri, methodRequest
      return response.code, response.body, response.to_hash
    end
  end
end
