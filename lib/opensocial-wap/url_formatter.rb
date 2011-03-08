# -*- coding: utf-8 -*-

# URL を OpenSocial WAP Extension 用に書き換える.
module OpensocialWap
  module UrlFormatter

    # アプリケーションサーバのURL(スキーム・FQDNも含む)を返す.
    # もし url が外部サーバであれば、FALSE を返す.
    def plain_url_for(url, host, protocol = nil, port = nil)
      # URL文字列をプロトコル部分とホスト部分に分割.
      url_parts = url.scan(%r{(^\w[\w+.-]*://)([\w\d\.:-]*)/?}).first
      if url_parts.nil? || url_parts[0].nil?
        # URL文字列がプロトコル部分を含まなければ、プロトコル、ホスト、ポートを付与する.
        base_url(host, protocol, port) + url
      elsif !url_parts[1].nil? && url_parts[1] != host
        # URLのホスト部分が、host引数と等しくなければ外部URL.
        false
      else
        url
      end
    end

    # クエリ形式("?url=エンコードされたURL")のURLを返す.
    # URL は スキーム・FQDNも含む形式にすること.
    def query_url_for(url, params = nil)
      params ||= {}
      params.merge!({ :url => url })
      "?" + params.select{|k,v| v}.collect{|k,v| "#{k}=#{ERB::Util.url_encode(v)}" }.join('&')
    end

    # コンテナのURLを含む形式の完全URL.
    # URL は スキーム・FQDNも含む形式にすること.
    def full_url_for(container_url, app_id, url, params = nil)
      # container_url の最後の文字が "/" であれば削除.
      if container_url[-1] == "/"
        container_url = container_url[0..-2]
      end
      "#{container_url}/#{app_id}/#{query_url_for(url, params)}"
    end

    # URLのうち、プロトコルとホストからなる部分を返す.
    def base_url(host, protocol = nil, port = nil)
      protocol ||= "http"
      protocol << "://" unless protocol.match("://")
      raise "Host is missing! Please provide host parameter" unless host
      url = "#{protocol}#{host}"
      url << ":#{port}" if port
      url
    end
  end
end
