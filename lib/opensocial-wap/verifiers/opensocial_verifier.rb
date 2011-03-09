# encoding: UTF-8

require 'oauth'
require 'oauth/helper'
require 'oauth/signature/rsa/sha1'

module OpensocialWap
  # OAuth検証やAPIリクエストを実行するためのクラス.
  class OpensocialVerifier
    include OAuth::Helper
    
    LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'

    attr_reader :gadget_server, :api_server, :consumer_key, :consumer_secret
    attr_accessor :request
    
    def initialize(options)
      options.each do |k, v|
        instance_variable_set "@#{k.to_s}", v
      end
    end

    # subclass MAY be override. it depends on the spec of opensocial services.
    def signature_base_string method, normalized_uri, parameters_for_signature, get_params, post_params
      normalized_params = normalize(parameters_for_signature)
      base = [method, normalized_uri, normalized_params]
      base.map { |v| escape(v) }.join("&")
    end
    
    # OAuth検証
    def verify_request(options = {})
      opts = { :consumer_secret => @consumer_secret, :token_secret => @request.parameters['oauth_token_secret'] }
      signature = OAuth::Signature.build(@request, opts)

      if @request.logger
        @request.logger.debug "oauth signature : #{OAuth::Signature.sign(@request, opts)}"
        @request.logger.debug "OauthHandler OAuth verification:"
        @request.logger.debug "  authorization header: #{@request.request.env['HTTP_AUTHORIZATION']}"
        @request.logger.debug "  base string:          #{signature.signature_base_string}"
        @request.logger.debug "  signature:            #{signature.signature}"      
      end
      signature.verify
    end
  end
end
