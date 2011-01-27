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
        @verifier= OpensocialOauthVerifier.new @platform, @skip_verify, @logging
      end
      
      def call(env)
        @logger ||= @logging ? env['rack.errors'] : nil
        log('call') if @logging

        env['opensocial-wap.rack'] ||= {}

        rack_request = ::Rack::Request.new env

        result = @verifier.verify rack_request, @logger

        unless result
          return result
        end

        status, env, response = @app.call(env)

        log("status = #{status}") if @logging
        log("env = #{env}") if @logging
        log("response = #{response}") if @logging
 
        response = remove_utf8_form_input_tag env, response

        new_response = ::Rack::Response.new(response, status, env)
        new_response.finish
      end

      private
      
      def log(msg)
        @logger.write "\n[#{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] OpensocialWap::Rack::OpensocialOauth #{msg} \n\n"
      end

      def response_to_body(response)
        if response.respond_to?(:to_str)
          response.to_str
        elsif response.respond_to?(:each)
          body = []
          response.each do |part|
            body << response_to_body(part)
          end
          body.join("\n")
        else
          body
        end
      end

      def remove_utf8_form_input_tag env, response
        if env['Content-Type'] =~ %r!text/html|application/xhtml\+xml!
          type, charset = env['Content-Type'].split(/;\s*charset=/)

          body = response_to_body(response)
          body = body.gsub(/<input name="utf8" type="hidden" value="#{[0x2713].pack("U")}"[^>]*?>/, ' ')
          body = body.gsub(/<input name="utf8" type="hidden" value="&#x2713;"[^>]*?>/, ' ')

          response.body = body
        end
        response
      end

    end

    module RequestWithOpensocialOauth
      def opensocial_oauth_skipped?
        env['opensocial-wap.rack']['OPENSOCIAL_OAUTH_SKIPPED'] ? true : false
      end
      def opensocial_oauth_verified?
        env['opensocial-wap.rack']['OPENSOCIAL_OAUTH_VERIFIED'] ? true : false
      end
    end

    class OpensocialOauthVerifier
      include RequestWithOpensocialOauth

      def initialize platform, skip_verify=false, logging=false
         @platform = platform
         @skip_verify = skip_verify
         @loggin = logging
      end

      def verify rack_request, logger=nil
        env = {}
        rack_request_proxy = OAuth::OpensocialOauthRequestProxy.new(@platform, rack_request)
        @platform.request = rack_request_proxy
        unless @skip_verify
          if rack_request.env['HTTP_AUTHORIZATION']
            is_valid_request = @platform.verify_request :logger=>logger
            if is_valid_request
              env['OPENSOCIAL_OAUTH_VERIFIED'] = true
            else
              return unauthorized
            end
          else
            # always false if HTTP_AUTHORIZATION header is not available.
            env['OPENSOCIAL_OAUTH_VERIFIED'] = false
          end
        else
          env['OPENSOCIAL_OAUTH_SKIPPED'] = true
          env['OPENSOCIAL_OAUTH_VERIFIED'] = true # always true if skipped.
        end
        rack_request.env['opensocial-wap.rack'].merge!(env)
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
