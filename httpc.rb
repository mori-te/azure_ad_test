#
# 簡易HTTP CLIENTモジュール
#
require 'uri'
require 'net/http'

module AzureAD
  class HTTPClient
    def initialize(options = {})
      @options = options
    end
    def http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https" ? true : false
      @options.each do |k, v|
        http.send("#{k}=", v)
      end
      http
    end
    def get(url, data = {}, header = {})
      params = data.empty? ? "" : "?" + URI.encode_www_form(data) 
      uri = URI.parse(url + params)
      http(uri).get(uri.request_uri, header)
    end
    def post(url, data, header = {})
      uri = URI.parse(url)
      body = URI.encode_www_form(data)
      http(uri).post(uri.request_uri, body, header)
    end
  end
end

# eos #