# -*- coding: utf-8 -*-
require 'opensocial-wap/oauth/request_proxy/oauth_rack_request_proxy'

# signature_base_string の構築に、POSTパラメータを含めないプラットフォーム用の request proxy.
module OpensocialWap::OAuth::RequestProxy
  class OAuthRackRequestProxyForMixi < OAuthRackRequestProxy
    
    def my_parameters
      merged_params = merge query_params_hash, header_params
    end
    
  end
end
