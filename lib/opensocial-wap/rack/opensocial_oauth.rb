# encoding: UTF-8

require 'rack'
require 'rack/request'
require 'rack/utils'
require 'oauth/request_proxy/rack_request'
require 'oauth/signature/rsa/sha1'
require 'cgi'

module OpensocialWap
  module Rack
    class LogLevel
      DEBUG   = 0
      INFO    = 1
      WARN    = 2
      ERROR   = 3
      FATAL   = 4
      UNKNOWN = 5
      LABELS=['DEBUG','INFO','WARN','ERROR','FATAL','UNKNOWN']
      def self.log_level_to_label log_level
        LABELS[log_level] 
      end
      def self.label_to_log_level log_level_label
        LABELS.index log_level_label.to_s.upcase
      end
    end
    class Logger
      LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'
      def initialize logger, log_level
        @logger = logger
        @log_level = log_level
      end
      def isDebug
         isLogLevel LogLevel::DEBUG
      end
      def isInfo
         isLogLevel LogLevel::INFO
      end
      def isWarn
         isLogLevel LogLevel::WARN
      end
      def isError
         isLogLevel LogLevel::ERROR
      end
      def isFatal
         isLogLevel LogLevel::FATAL
      end
      def isLogLevel log_level
         log_level <= @log_level
      end
      def debug msg
        log LogLevel::DEBUG, msg
      end
      def info msg
        log LogLevel::INFO, msg
      end
      def warn msg
        log LogLevel::WARN, msg
      end
      def error msg
        log LogLevel::ERROR, msg
      end
      def fatal msg
        log LogLevel::FATAL, msg
      end
      def log(log_level, msg)
        if isLogLevel log_level
          @logger.write "\n[#{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] #{LogLevel::log_level_to_label(log_level)} #{msg}"
        end
      end
    end
    class OpensocialOauth
      include ::Rack::Utils
      
      def initialize(app, opt={})
        @app = app
        @platform = opt[:platform]
        @log_level = LogLevel::label_to_log_level opt[:log_level] 
        @verifier= OpensocialOauthVerifier.new @platform
      end
      
      def call(env)
        @logger ||= Logger.new env['rack.errors'], @log_level
        @logger.debug "rack.env['HTTP_AUTHORIZATION'] = #{env['HTTP_AUTHORIZATION']}"
        # marker
        env['opensocial-wap.rack'] ||= {}
        rack_request = ::Rack::Request.new env
        @verifier.verify rack_request, @logger 

        status, header, response = @app.call(env)
 
        response = remove_utf8_form_input_tag header, response

        new_response = ::Rack::Response.new(response, status, header)
        new_response.finish
      end

      private
      
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

      def initialize platform 
         @platform = platform
      end

      def verify rack_request, logger=nil
        env = {}
        rack_request_proxy = OAuth::OpensocialOauthRequestProxy.new(@platform, rack_request, logger)
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
    def initialize(platform, request, logger, options = {})
      super request, options
      @platform = platform
      @logger = logger
    end
    def parameters
      if options[:clobber_request]
        options[:parameters] || {}
      else
        params = request_raw_params.merge(query_params).merge(header_params)
        params = params.merge(options[:parameters] || {})
        #if @logger and @logger.isDebug
        #  @logger.debug "request_params = #{request_raw_params}"
        #  @logger.debug "query_params = #{query_params}"
        #  @logger.debug "header_params = #{header_params}"
        #  @logger.debug "all(request,query,header) merged params = #{params}"
        #end
        params 
      end
    end
    def request_raw_params
       @request.POST
       form_params = @request.env['rack.request.form_vars']
       if form_params && form_params.size > 0 
         form_params.split('&').inject({}) do |hsh, i| kv = i.split('='); hsh[CGI::unescape(kv[0])] = kv[1] ? CGI::unescape(kv[1]) : '' ; hsh end
       else
         {}
       end
    end
    def signature_base_string
      sbs = @platform.signature_base_string method, normalized_uri, parameters_for_signature, query_params, request_params
      if @logger and @logger.isDebug
        @logger.debug "signature_base_string = #{sbs}"
      end
      sbs
    end
  end
end

class Rack::Request
  include OpensocialWap::Rack::RequestWithOpensocialOauth
end
