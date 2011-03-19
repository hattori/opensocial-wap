module OpensocialWap
  module OAuth
    module Helpers
      class Base

        def initialize(request)
          @request = request
        end
        
        def verify(options = nil)
          raise 'Not implemented.'
        end
        
        def authorization_header(api_request, options = nil)
          raise 'Not implemented.'
        end
      end
    end
  end
end
