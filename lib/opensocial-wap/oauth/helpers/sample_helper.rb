require 'oauth'
require 'oauth/signature/rsa/sha1'

module OpensocialWap
  module OAuth
    module Helpers
      class SampleHelper < BasicHelper

        private 

        def request_proxy(request)
          ::OpensocialWap::OAuth::RequestProxy::SampleRackRequest.new(request)
        end
      end
    end
  end
end
