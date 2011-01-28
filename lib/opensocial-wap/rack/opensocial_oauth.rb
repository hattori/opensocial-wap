# encoding: UTF-8

require 'rack'
require 'rack/request'
require 'rack/utils'
require 'oauth/request_proxy/rack_request'
require 'oauth/signature/rsa/sha1'

module OpensocialWap
  module Rack
    module LogLevel
      DEBUG   = 0
      INFO    = 1
      WARN    = 2
      ERROR   = 3
      FATAL   = 4
      UNKNOWN = 5
      LABELS=['DEBUG','INFO','WARN','ERROR','FATAL','UNKNOWN']
      def log_level_to_label log_level
        LABELS[log_level] 
      end
      def label_to_log_level log_level_label
        LABELS.index log_level_label.to_s.upcase
      end
    end
    class OpensocialOauth
      include ::Rack::Utils
      include LogLevel
      
      LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'
      
      def initialize(app, opt={})
        @app = app
        @platform = opt[:platform]
        @log_level = label_to_log_level opt[:log_level] 
        @verifier= OpensocialOauthVerifier.new @platform, @log_level
      end
      
      def call(env)
        @logger ||= env['rack.errors'] 

        env['opensocial-wap.rack'] ||= {}

        rack_request = ::Rack::Request.new env

        @verifier.verify rack_request, @logger 

        status, env, response = @app.call(env)

        log(DEBUG, "status = #{status}") 
        log(DEBUG, "env = #{env}")
        log(DEBUG, "response = #{response}") 
 
        response = remove_utf8_form_input_tag env, response

        new_response = ::Rack::Response.new(response, status, env)
        new_response.finish
      end

      private
      
      def log(log_level=DEBUG, msg) 
        return if log_level < @log_level 
        @logger.write "\n[#{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] #{log_level_to_label(log_level)} OpensocialWap::Rack::OpensocialOauth #{msg} \n\n"
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
      def opensocial_oauth_verified?
        env['opensocial-wap.rack']['OPENSOCIAL_OAUTH_VERIFIED'] ? true : false
      end
    end

    class OpensocialOauthVerifier
      include RequestWithOpensocialOauth
      include LogLevel

      def initialize platform, log_level=ERROR
         @platform = platform
         @log_level = log_level
      end

      def verify rack_request, logger=nil
        env = {}
        rack_request_proxy = OAuth::OpensocialOauthRequestProxy.new(@platform, rack_request)
        @platform.request = rack_request_proxy
        if rack_request.env['HTTP_AUTHORIZATION']
          is_valid_request = @platform.verify_request :logger=>logger
          if is_valid_request
            env['OPENSOCIAL_OAUTH_VERIFIED'] = true
          else
            env['OPENSOCIAL_OAUTH_VERIFIED'] = false
          end
        else
          # false if HTTP_AUTHORIZATION header is not available.
          env['OPENSOCIAL_OAUTH_VERIFIED'] = false
        end
        rack_request.env['opensocial-wap.rack'].merge!(env)
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
