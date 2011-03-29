require 'oauth'
require 'oauth/signature/rsa/sha1'
require 'opensocial-wap/oauth/request_proxy/sample_rack_request'

module OpensocialWap
  module OAuth
    module Helpers
      class SampleHelper < BasicHelper

        private 

        def request_proxy
          ::OpensocialWap::OAuth::RequestProxy::SampleRackRequest.new(@request)
        end
      end
    end
  end
end
