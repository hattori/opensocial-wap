module OpensocialWap
  module OAuth
    module Helpers
      class BasicHelper
        def initialize(options)
          options.each do |k, v|
            instance_variable_set "@#{k.to_s}", v
          end
        end

        def verify(request, options = nil)
          opts = { 
            :consumer_secret => @consumer_secret, 
            :token_secret => request.parameters['oauth_token_secret'] }
          signature = OAuth::Signature.build(request, opts)
          signature.verify
        end

        def sign(request, options = nil)

        end
      end
    end
  end
end
