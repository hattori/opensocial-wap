# -*- coding: utf-8 -*-

module OpensocialWap
  module Rack
    class OpensocialOauthRequestProxy < ::OAuth::RequestProxy::RackRequest

      def initialize(verifier, request, options = {})
        super request, options
        @verifier = verifier
      end
      
      def parameters
        if options[:clobber_request]
          options[:parameters] || {}
        else
          params = request_raw_params.merge(query_params).merge(header_params)
          params = params.merge(options[:parameters] || {})
          if logger
            logger.debug "  request_params = #{request_raw_params}"
            logger.debug "  query_params = #{query_params}"
            logger.debug "  header_params = #{header_params}"
            logger.debug "  all(request,query,header) merged params = #{params}"
          end
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
        logger.debug "  signature_base_string = #{sbs}" if logger
        sbs
      end
      
      def logger
        @request.logger      
      end
    end
  end
end
