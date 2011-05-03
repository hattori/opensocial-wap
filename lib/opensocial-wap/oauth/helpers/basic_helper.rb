require 'oauth'
require 'oauth/signature/rsa/sha1'

module OpensocialWap
  module OAuth
    module Helpers
      class BasicHelper < Base

        DEFAULT_PROXY_CLASS = ::OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxy
        
        def verify(options = nil)
          request_proxy = self.class.proxy_class.new(@request)

          opts = {
            :consumer_secret => self.class.consumer_secret,
            :token_secret => request_proxy.parameters['oauth_token_secret'] }
          @access_token = ::OAuth::AccessToken.new(consumer,
                                                   request_proxy.parameters['oauth_token'],
                                                   request_proxy.parameters['oauth_token_secret'])
          signature = ::OAuth::Signature.build(request_proxy, opts)
          
          if logger = @request.logger
            logger.debug "oauth signature : #{::OAuth::Signature.sign(request_proxy, opts)}"
            logger.debug "=== OauthHandler OAuth verification: ==="
            logger.debug "  authorization header: #{@request.env['HTTP_AUTHORIZATION']}"
            logger.debug "  base string:          #{signature.signature_base_string}"
            logger.debug "  signature:            #{signature.signature}"      
          end

          signature.verify
        rescue Exception => e
          false
        end        

        def authorization_header(api_request, options = nil)
          opts = { :consumer => consumer }
          opts[:token] = access_token if access_token
          if @request
            opts[:xoauth_requestor_id] = @request.params['opensocial_viewer_id'] || @request.params['opensocial_owner_id']
          end
          oauth_client_helper = ::OAuth::Client::Helper.new(api_request, opts.merge(options))
          oauth_client_helper.header
        end

        def api_endpoint
          self.class.api_endpoint
        end

        def self.configure(&blk)
          instance_eval(&blk)
          self
        end

        private

        def self.consumer_key(arg = nil)
          if arg
            @consumer_key = arg
          end
          @consumer_key.dup if @consumer_key
        end
        
        def self.consumer_secret(arg = nil)
          if arg
            @consumer_secret = arg
          end
          @consumer_secret.dup if @consumer_secret
        end

        def self.api_endpoint(arg = nil)
          if arg
            @api_endpoint = arg
          end
          @api_endpoint.dup if @api_endpoint
        end

        def self.proxy_class(arg = nil)
          if arg
            @proxy_class = arg
          end
          @proxy_class || DEFAULT_PROXY_CLASS
        end

        def consumer 
          @consumer ||= ::OAuth::Consumer.new(self.class.consumer_key, self.class.consumer_secret)
        end

        def access_token
          @access_token
        end

      end
    end
  end
end
