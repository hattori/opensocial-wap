module OpensocialWap
  module OAuth
    module Helpers
      class Base

        def initialize(request = nil)
          @request = request
        end
        
        def verify(options = nil)
          raise NotImplementedError
        end
        
        def authorization_header(api_request, options = nil)
          raise NotImplementedError
        end

        def api_endpoint
          raise NotImplementedError
        end

        def client_helper(*args)
          ::OpensocialWap::OAuth::ClientHelper.new(self, args)
        end
      end
    end
  end
end
