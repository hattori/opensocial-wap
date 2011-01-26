# -*- coding: utf-8 -*-

module OpensocialWap
  module Routing
    module UrlFor

      # OpenSocial WAP Extension 用 url_for.
      def url_for(options = nil, osw_options = {:url_format => nil, :params => {}})
        url_format = osw_options && osw_options[:url_format]        
        return super(options) unless url_format
        
        # アプリケーションサーバの完全URL(:only_path => false を指定したときのURL)
        options ||= {}
        url = case options
              when String
                opts = options_for_full_url(nil, osw_options)
                base_url(opts) + options
              when Hash
                opts = options_for_full_url(options, osw_options)
                url_for(opts)
              else
                opts = options_for_full_url(nil, osw_options)
                polymorphic_url(options, opts)
              end
        
        case url_format
        when :plain
          url
        when :query
          query_url_for(url, osw_options[:params])
        when :full
          full_url_for(url, osw_options, params[:opensocial_app_id])
        end
      end
      
      private

      # アプリサーバ側の完全URLを構築するためのオプション.
      def options_for_full_url(options = {}, osw_options = {})
        options ||= {}
        options.reverse_merge!(url_options).symbolize_keys
        options[:only_path] = false
        [:protocol, :host, :port].each do |key|
          options[key] ||= osw_options[key] if osw_options.key?(key) 
        end
        options
      end
      
      # クエリ形式("?url=エンコードされたURL")のURL.
      def query_url_for(url, params)
        params = (params || {}).merge({:url =>url})
        "?" + params.select{|k,v| v}.collect{|k,v| "#{k}=#{ERB::Util.url_encode(v)}" }.join('&')
      end
      
      # コンテナのURLを含む形式の完全URL.
      def full_url_for(url, osw_options, app_id)
        protocol = url.scan(%r{^\w[\w+.-]*://}).first
        host = osw_options[:container_host]
        params = osw_options[:params]
        base_url({ :protocol => protocol, :host => host }) + "/#{app_id}/#{query_url_for(url, params)}"
      end
      
      # URLのプロトコルとホスト部分.
      def base_url(options = {})
        url = ""
        url << (options[:protocol] || "http")
        url << "://" unless url.match("://")
        raise "Missing host to link to! Please provide :host parameter or set default_url_options[:host]" unless options[:host]
        url << options[:host]
        url << ":#{options.delete(:port)}" if options.key?(:port)
        url
      end
    end
  end
end
