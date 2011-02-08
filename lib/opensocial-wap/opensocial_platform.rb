# encoding: UTF-8

require 'oauth'
require 'oauth/helper'
require 'oauth/signature/rsa/sha1'

module OpensocialWap
  # OAuth検証やAPIリクエストを実行するためのクラス.
  class OpensocialPlatform
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
      logger = options[:logger]
      opts = { :consumer_secret => @consumer_secret, :token_secret => @request.parameters['oauth_token_secret'] }
      signature = OAuth::Signature.build(@request, opts)

      if logger and logger.isDebug
        logger.debug "oauth signature : #{OAuth::Signature.sign(@request, opts)}"
      end

      #if options && options[:logger]
      #  logger = options[:logger]
      #  logger.write "[#{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] OauthHandler OAuth verification:"
      #  logger.write "  authorization header: #{@request.request.env['HTTP_AUTHORIZATION']}"
      #  logger.write "  base string:          #{signature.signature_base_string}"
      #  logger.write "  signature:            #{signature.signature}"      
      #end
      signature.verify
    end

    # APIリクエストを実行する.
    def method_missing(method_id, *params)
      # メソッドを"_"で分割し、前をリクエストメソッド、後ろをAPI識別子とする.
      method, api = method_id.id2name.split('_', 2)
      api_request = ApiRequest.new(@platform, 
                                   consumer, 
                                   api, 
                                   params[0], 
                                   params[1], 
                                   { :xoauth_requestor_id => @request.parameters['opensocial_viewer_id'] })
      response = api_request.send(method)
      unless response.code =~ /2\d\d/
        raise ApiException.new(api_request, response.code, response.message, response.body)
      end
      result = JSON.parse response.body
      result['entry']
    end

    private 

    def consumer
      opts = {
        :scheme => 'header',
        :signature_method => 'HMAC-SHA1',
        :oauth_version => "1.0" 
      }
      OAuth::Consumer.new(@consumer_key, @consumer_secret, opts)
    end
  end
end
