# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun_sls_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "aliyun_sls_sdk"
  spec.version       = AliyunSlsSdk::VERSION
  spec.authors       = ["linhua.tlh"]
  spec.email         = ["tlh1987@gmail.com"]
  spec.description   = %q{Gem for SDK of SLS of Aliyun}
  spec.summary       = %q{Gem for SDK of SLS of Aliyun, use it at your own risk}
  spec.homepage      = "https://help.aliyun.com/product/28958.html"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_dependency "beefcake", "~> 1.2"
  spec.add_dependency "file-tail", "~> 0"
  spec.add_dependency "ruby-hmac", "~> 0"
  spec.add_dependency "addressable", "~> 2.5"
  spec.add_dependency "net-http-persistent", "~> 3.0"
end
