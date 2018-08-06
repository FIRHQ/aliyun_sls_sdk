require "uri"
require "base64"
require "zlib"
require "hmac-sha1"


module AliyunSlsSdk
  class Util
    def self.compress_data(data)
      Zlib::Deflate.deflate(data, 6)
    end

    def self.cal_md5(content)
      Digest::MD5.hexdigest(content).upcase
    end

    def self.hmac_sha1(content, key)
      Base64.encode64((HMAC::SHA1.new(key) << content).digest).rstrip()
    end

    def self.canonicalized_log_headers(headers)
      h = {}
      headers.each { |k, v|
        if k =~ /x-log-.*/ or k =~ /x-acs-.*/
          h[k.downcase] = v
        end
      }
      h.keys.sort.map { |e|
        "#{e}:#{h[e].gsub(/^\s+/, '')}"
      }.join($/) + $/
    end

    def self.url_encode(params)
      # todo
    end

    def self.canonicalized_resource(resource, params)
      if not params.empty?
        urlString = params.keys.sort.map { |k|
          "#{k}=#{params[k]}"
        }.join('&')
        return resource+"?"+urlString
      else
        return resource
      end
    end

    def self.get_request_authorization(method, resource, key, params, headers)
      if not key
        return ''
      end
      content = method + "\n"
      if  headers['Content-MD5']
            content += headers['Content-MD5']
      end
      content += "\n"
      if headers['Content-Type']
          content += headers['Content-Type']
      end
      content += "\n"
      content += headers['Date']+"\n"
      content += Util.canonicalized_log_headers(headers)
      content += Util.canonicalized_resource(resource, params)
      return Util.hmac_sha1(content, key)
    end
  end
end
