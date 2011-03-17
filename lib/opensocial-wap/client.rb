# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'

module OpensocialWap
  module Client
    class Base
      attr_accessor :options, :endpoint, :port, :headers, :post_data
      
      def initialize(args)
        args.each do |k, v|
          instance_variable_set "@#{k.to_s}", v
        end
        @port ||= 80
      end
      
      # Authorizationヘッダを計算して返す.
      def authorization_header
        client_helper.header
      end
      
      # API 呼び出し実行.
      def run
        raise 'Run method should be implemented in the sub classes.'
      end
      
      # HTTPリクエストオブジェクトを返す.
      def request
        raise 'Request method should be implemented in the sub classes.'
      end
      
      # 引数から接続先URLを構築してセットする.
      def method_missing(name, *args)
        unless endpoint
          raise "Endpoint is not set."
        end
        @url = endpoint
        
        # 最後の引数が Hash であれば、GETパラメータとする.
        get_params = nil
        @url << '/' if @url[-1] != '/'
        if args[-1] && (args[-1].is_a? Hash)
          get_params = args.pop
        end
        
        # URL を構築.
        @url << "#{name}/"
        @url << args.map{|arg| arg.to_s}.join('/')
        @url << '/'
        if get_params && get_params.size > 0
          @url << (@url.index('?') ? '&' : '?')
          @url << parameter_string(get_params)
        end
        @uri = URI.parse(@url)
        self
      end
      
      # リクエスト先URLを返す.
      def url
        @url
      end
      
      private
      
      def client_helper
        OpensocialWap::Client::Helper.new(request, options.merge(:request_uri => @url))
      end
      
      def parameter_string(hash)
        str = ''
        if hash && hash.size > 0
          str << hash.map{|k,v| "#{k.to_s}=#{URI.encode(v.to_s, /[^\w]/)}"}.join('&')
        end
        str
      end
      
      def post_data_string
        case @post_data
        when String
          @post_data
        when Hash
          parameter_string(@post_data)
        else
          nil
        end
      end
    end
    
    class Get < Base
      def request
        Net::HTTP::Get.new(@uri.request_uri)
      end
      def run
        request_headers = (headers || {}).merge("Authorization" => authorization_header)
        Net::HTTP::start(@uri.host, @port) do |http|
          @response = http.get(@uri.request_uri, request_headers)
        end
      end
      @response
    end
    
    class Post < Base
      def request
        req = Net::HTTP::Post.new(@uri.request_uri)
        req.body = post_data_string
        req
      end
      def run
        request_headers = (headers || {}).merge("Authorization" => authorization_header)
        Net::HTTP::start(@uri.host, @port) do |http|
          @response = http.post(@uri.request_uri, post_data_string, request_headers)
        end
        @response
      end
    end
    
    class Head < Base
      def request
        Net::HTTP::Head.new(@uri.request_uri)
      end
      def run
        request_headers = (headers || {}).merge("Authorization" => authorization_header)
        Net::HTTP::start(@uri.host, @port) do |http|
          @response = http.head(@uri.request_uri, request_headers)
        end
        @response
      end
    end
    
    class Put < Base
      def request
        Net::HTTP::Put.new(@uri.request_uri)
        req.body = post_data_string
        req
      end
      def run
        request_headers = (headers || {}).merge("Authorization" => authorization_header)
        Net::HTTP::start(@uri.host, @port) do |http|
          @response = http.put(@uri.request_uri, post_data_string, request_headers)
        end
        @response
      end
    end
  end
end
