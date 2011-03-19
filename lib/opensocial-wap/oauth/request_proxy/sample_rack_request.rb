# -*- coding: utf-8 -*-
require 'oauth/request_proxy/rack_request'

module OpensocialWap
  module OAuth
    module RequestProxy

      # RequestProxy class that does not use POST parameters for parameters_for_signature.
      class SampleRackRequest < ::OAuth::RequestProxy::RackRequest

        def parameters_for_signature
          # signatture用パラメータから、POSTパラメータを削除.
          super.reject { |k,v| request_params.has_key?(k)}
        end
      end
    end
  end
end
