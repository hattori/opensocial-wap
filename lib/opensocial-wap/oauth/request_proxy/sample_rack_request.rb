# -*- coding: utf-8 -*-
require 'oauth/request_proxy/rack_request'
require 'opensocial-wap/oauth/request_proxy/basic_rack_request'

module OpensocialWap::OAuth::RequestProxy
  module SampleRackRequest
    def self.included(base)
      base.class_eval do
        # Do not use POST parameters for parameters_for_signature.
        def parameters_for_signature
          # signatture用パラメータから、POSTパラメータを削除.
          super.reject { |k,v| request_params.has_key?(k)}
        end
      end
    end
  end
end

class OAuth::RequestProxy::RackRequest
  include ::OpensocialWap::OAuth::RequestProxy::BasicRackRequest
  include ::OpensocialWap::OAuth::RequestProxy::SampleRackRequest
end
