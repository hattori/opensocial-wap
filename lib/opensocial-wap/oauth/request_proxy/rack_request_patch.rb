# -*- coding: utf-8 -*-
require 'oauth/request_proxy/rack_request'

module OpensocialWap::OAuth::RequestProxy
  module RackRequestPatch
    def self.included(base)
      base.class_eval do
        
        private
        
        # request.POST は env["rack.request.form_hash"] の値を返すが、POSTデータ中に
        # "..var%5Bkey%5D=123.." のような部分があると、"var"=>{"key"=>"123"} という
        # 形式に変換してしまう.
        # これを、"var[key]"=>"123" を返すように修正する.
        def request_params
          post = request.POST
          form_params = request.env['rack.request.form_vars']
          if form_params && form_params.size > 0
            form_params.split('&').inject({}) do |hsh, i|
              kv = i.split('=')
              hsh[::Rack::Utils::unescape(kv[0])] = kv[1] ? ::Rack::Utils::unescape(kv[1]) : ''
              hsh
            end
          else
            {}
          end
        end
      end
    end
  end
end

class OAuth::RequestProxy::RackRequest
  include ::OpensocialWap::OAuth::RequestProxy::RackRequestPatch
end

