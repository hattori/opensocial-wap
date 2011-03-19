# -*- coding: utf-8 -*-

# ActionDispatch::Routing::UrlFor を拡張.
module OpensocialWap
  module Routing
    module UrlFor
      include UrlFormatter

      # OpenSocial WAP Extension 用 url_for.
      def url_for(options = nil, url_settings = nil)
        url_format = url_settings && url_settings[:format]
        return super(options) unless url_format

        # アプリケーションサーバの完全URL(:only_path => false を指定したときのURL)を作成.
        options ||= {}
        url = case options
              when String
                opts = options_for_plain_url(nil, url_settings)
                plain_url = plain_url_for(options, opts[:host], opts[:protocol], opts[:port])
                unless plain_url
                  # 外部URLであれば、そのまま返す.
                  return options
                end
                plain_url
              when Hash
                opts = options_for_plain_url(options, url_settings)
                url_for(opts)
              else
                opts = options_for_plain_url(nil, url_settings)
                polymorphic_url(options, opts)
              end
        # url_format に従って、URLを書き換える.
        format_url(url, url_settings)
      end
      
      private

      # URL を OpenSocial WAP Extension 用に書き換える.
      # URL は スキーム・FQDNも含む形式にすること.
      def format_url(url, url_settings)
        url_format = url_settings && url_settings[:format]
        case url_format
        when :query
          query_url_for(url, url_settings[:params])
        when :full
          protocol = url.scan(%r{^\w[\w+.-]*://}).first
          container_url = base_url(url_settings[:container_host], protocol)
          full_url_for(container_url, params[:opensocial_app_id], url, url_settings[:params])
        else
          url 
        end
      end

      # アプリサーバ側の完全URLを構築するためのオプション.
      def options_for_plain_url(options = {}, url_settings = {})
        options ||= {}
        options.reverse_merge!(url_options).symbolize_keys
        options[:only_path] = false
        [:protocol, :host, :port].each do |key|
          if url_settings.key?(key)
            options[key] = url_settings[key]
          elsif url_options.key?(key)
            options[key] = url_options[key]
          end
        end
        options
      end
    end
  end
end
