# -*- coding: utf-8 -*-

# ActionDispatch::Routing::UrlFor を拡張.
module OpensocialWap
  module Routing
    module UrlFor
      include ::OpensocialWap::UrlFormatter

      # OpenSocial WAP Extension 用 url_for.
      def url_for(options = nil, osw_options = {:params => {}})
        url_format = osw_options && osw_options[:url_format]
        return super(options) unless url_format

        # アプリケーションサーバの完全URL(:only_path => false を指定したときのURL)
        options ||= {}
        url = case options
              when String
                opts = options_for_full_url(nil, osw_options)
                plain_url = plain_url_for(options, opts[:host], opts[:protocol], opts[:port])
                unless plain_url
                  # 外部URLであれば、そのまま返す.
                  return options
                end
                plain_url
              when Hash
                opts = options_for_full_url(options, osw_options)
                url_for(opts)
              else
                opts = options_for_full_url(nil, osw_options)
                polymorphic_url(options, opts)
              end
        
        format_url(url, osw_options)
      end
      
      private

      # URL を OpenSocial WAP Extension 用に書き換える.
      # URL は スキーム・FQDNも含む形式にすること.
      def format_url(url, osw_options)
        url_format = osw_options && osw_options[:url_format]
        case url_format
        when :query
          query_url_for(url, osw_options[:params])
        when :full
          protocol = url.scan(%r{^\w[\w+.-]*://}).first
          container_url = base_url(osw_options[:container_host], protocol)
          full_url_for(container_url, params[:opensocial_app_id], url, osw_options[:params])
        else
          url 
        end
      end

      # アプリサーバ側の完全URLを構築するためのオプション.
      def options_for_full_url(options = {}, osw_options = {})
        options ||= {}
        options.reverse_merge!(url_options).symbolize_keys
        options[:only_path] = false
        [:protocol, :host, :port].each do |key|
          if osw_options.key?(key)
            options[key] = osw_options[key]
          elsif url_options.key?(key)
            options[key] = url_options[key]
          end
        end
        options
      end
    end
  end
end
