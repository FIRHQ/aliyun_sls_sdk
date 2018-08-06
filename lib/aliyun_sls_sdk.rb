require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'version.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'protobuf.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'log_request.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'get_log_request.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'put_logs_request.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'log_response.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'put_logs_response.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'util.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'log_client.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'log_item.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'create_log_store_response.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'get_log_store_response.rb')
require File.join(File.dirname(__FILE__), 'aliyun_sls_sdk', 'log_exception.rb')

module AliyunSlsSdk
  class PostBodyInvalid < RuntimeError;
  end
  class SLSInvalidTimestamp < RuntimeError;
  end
  class SLSInvalidEncoding < RuntimeError;
  end
  class SLSInvalidKey < RuntimeError;
  end
  class PostBodyTooLarge < RuntimeError;
  end
  class PostBodyUncompressError < RuntimeError;
  end
  class SLSLogStoreNotExist < RuntimeError;
  end
end
