# -*- coding: utf-8 -*-

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
        @helper_class = opt[:helper_class]
      end
      
      def call(env)
        logger = env['rack.logger']
        logger.debug "rack.env['HTTP_AUTHORIZATION'] = #{env['HTTP_AUTHORIZATION']}" if logger

        verify(env)

        status, header, response = @app.call(env)
 
        response = remove_utf8_form_input_tag header, response
        new_response = ::Rack::Response.new(response, status, header)
        new_response.finish
      end

      private

      def verify(env)
        verified = false
        request = ::Rack::Request.new(env)
        helper = @helper_class.new(request)

        if request.env['HTTP_AUTHORIZATION']
          if helper.verify
            verified = true
          else
            verified = false
          end
        else
          # false if HTTP_AUTHORIZATION header is not available.
          verified = false
        end
        request.env['opensocial-wap.oauth-verified'] = verified
        request.env['opensocial-wap.helper'] = helper
        verified
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
          if body.encoding == Encoding::UTF_8
            body = body.gsub(/<input name="utf8" type="hidden" value="#{[0x2713].pack("U")}"[^>]*?>/, ' ')
            body = body.gsub(/<input name="utf8" type="hidden" value="&#x2713;"[^>]*?>/, ' ')
            
            response.body = body
          end
        end
        response
      end

      def unauthorized
        [ 401,
          { 'Content-Type' => 'text/plain',
            'Content-Length' => '0'
          },
          []
        ]
      end
    end
  end
end
