require 'opensocial-wap/oauth/request_proxy/oauth_rack_request_proxy'

module OpensocialWap::OAuth::RequestProxy
  class OAuthRackRequestProxyForMixi < OAuthRackRequestProxy
    
    def my_parameters
      merged_params = merge query_params_hash, header_params
    end
    
  end
end