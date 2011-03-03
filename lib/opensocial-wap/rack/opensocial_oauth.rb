# encoding: UTF-8

require 'rack'
require 'rack/request'
require 'rack/utils'
require 'oauth/request_proxy/rack_request'
require 'oauth/signature/rsa/sha1'
require 'cgi'

module OpensocialWap
  module Rack
    class OpensocialOauth
      include ::Rack::Utils
      
      def initialize(app, opt={})
        @app = app
        @verifier= opt[:verifier]
        @log_level = LogLevel::label_to_log_level opt[:log_level] 
        @oauth_verifier= OpensocialOauthVerifier.new @verifier
      end
      
      def call(env)
        @logger ||= Logger.new env['rack.errors'], @log_level
        @logger.debug "rack.env['HTTP_AUTHORIZATION'] = #{env['HTTP_AUTHORIZATION']}"
        # marker
        env['opensocial-wap.rack'] ||= {}
        rack_request = ::Rack::Request.new env
        @oauth_verifier.verify rack_request, @logger 

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

    class OpensocialOauthVerifier

      def initialize verifier
         @verifier = verifier 
      end

      def verify rack_request, logger=nil
        env = {}
        rack_request_proxy = OAuth::OpensocialOauthRequestProxy.new(@verifier, rack_request, logger)
        @verifier.request = rack_request_proxy
        if rack_request.env['HTTP_AUTHORIZATION']
          is_valid_request = @verifier.verify_request :logger=>logger
          if is_valid_request
            env['OPENSOCIAL_OAUTH_VERIFIED'] = true
          else
            env['OPENSOCIAL_OAUTH_VERIFIED'] = false
          end
        else
          # false if HTTP_AUTHORIZATION header is not available.
          env['OPENSOCIAL_OAUTH_VERIFIED'] = false
        end
        rack_request.env['opensocial-wap.rack'] ||= {}
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
    def initialize(verifier, request, logger, options = {})
      super request, options
      @verifier = verifier
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
      sbs = @verifier.signature_base_string method, normalized_uri, parameters_for_signature, query_params, request_params
      if @logger and @logger.isDebug
        @logger.debug "signature_base_string = #{sbs}"
      end
      sbs
    end
  end
end
