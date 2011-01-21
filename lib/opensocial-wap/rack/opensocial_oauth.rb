# encoding: UTF-8

require 'rack'
require 'rack/request'
require 'rack/utils'
require 'oauth/request_proxy/rack_request'
require 'oauth/signature/rsa/sha1'

module OpensocialWap
  module Rack
    class OpensocialOauth
      include ::Rack::Utils
      
      LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'
      
      def initialize(app, opt={})
        @app = app
        @platform = opt[:platform]
        @skip_verify = opt[:skip] == true ? true : false
        @logging = opt[:logging] == true ? true : false
        @logic = OpensocialOauthVerification.new @platform, @skip_verify, @logging
      end
      
      def call(env)
        @logger ||= @logging ? env['rack.errors'] : nil
        log('call') if @logging
        rack_request = ::Rack::Request.new env
        result = @logic.verify rack_request, @logger
        unless result
          return result
        end
        @app.call(env)
      end

      private
      
      def log(msg)
        @logger.write "\n[#{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] OpensocialWap::Rack::OpensocialOauth #{msg} \n\n"
      end
    end

    class OpensocialOauthVerification
      def initialize platform, skip_verify=false, logging=false
         @platform = platform
         @skip_verify = skip_verify
         @loggin = logging
      end

      def verify rack_request, logger=nil
        rack_request_proxy = OAuth::OpensocialOauthRequestProxy.new(@platform, rack_request)
        @platform.request = rack_request_proxy
        unless @skip_verify
          if rack_request.env['HTTP_AUTHORIZATION']
            is_valid_request = @platform.verify_request :logger=>logger
            if is_valid_request
              rack_request.env['OPENSOCIAL_OAUTH_VERIFIED'] = true
            else
              return unauthorized
            end
          else
            # always false if HTTP_AUTHORIZATION header is not available.
            rack_request.env['OPENSOCIAL_OAUTH_VERIFIED'] = false
          end
        else
          rack_request.env['OPENSOCIAL_OAUTH_SKIPPED'] = true
          rack_request.env['OPENSOCIAL_OAUTH_VERIFIED'] = true # always true if skipped.
        end
        true
      end

      def unauthorized
        return [ 401,
          { 'Content-Type' => 'text/plain',
            'Content-Length' => '0'
            },
          []
        ]
      end
    end
    
    module RequestWithOpensocialOauth
      def opensocial_oauth_skipped?
        env['OPENSOCIAL_OAUTH_SKIPPED'] ? true : false
      end
      def opensocial_oauth_verified?
        env['OPENSOCIAL_OAUTH_VERIFIED'] ? true : false
      end
    end
  end
end

module OAuth
  class OpensocialOauthRequestProxy < OAuth::RequestProxy::RackRequest
    def initialize(platform, request, options = {})
      super request, options
      @platform = platform
    end
    def signature_base_string
      @platform.signature_base_string method, normalized_uri, parameters_for_signature, query_params, request_params
    end
  end
end

class Rack::Request
  include OpensocialWap::Rack::RequestWithOpensocialOauth
end
