module OpensocialWap
  module OAuth
    module Helpers
      class Base
        def verify(request, options = nil)
          raise 'Not implemented.'
        end

        def sign!(request, options = nil)
          raise 'Not implemented.'
        end
      end
    end
  end
end
