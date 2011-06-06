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
 
        response = remove_utf8_form_input_tag_from_response(header, response)
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

      def remove_utf8_form_input_tag_from_response(env, response)
        unless response.respond_to?(:body=)
          return response
        end
        if env['Content-Type'] =~ %r!text/html|application/xhtml\+xml!
          type, charset = env['Content-Type'].split(/;\s*charset=/)
          
          if response.respond_to?(:to_str)
            response.body = remove_utf8_form_input_tag(response.to_str)
          elsif response.respond_to?(:each)
            body = []
            response.each do |part|
              body << remove_utf8_form_input_tag(part)
            end
            response.body = body
          else
            response.body = remove_utf8_form_input_tag(response.body)
          end
        end
        response
      end

      def remove_utf8_form_input_tag(str)
        if str.encoding == Encoding::UTF_8
          str
            .gsub(/<input name="utf8" type="hidden" value="#{[0x2713].pack("U")}"[^>]*?>/, ' ')
            .gsub(/<input name="utf8" type="hidden" value="&#x2713;"[^>]*?>/, ' ')
        else
          str
        end
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
