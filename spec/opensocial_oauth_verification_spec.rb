require 'rack'
require 'oauth'
require 'opensocial-wap'
require 'opensocial-wap/rack/opensocial_oauth'

module OpensocialWap
  module Rack

    describe OpensocialOauthVerifier do
      context "a normal (oauth NOT signed) get request from sns" do
        it "must be failed to verify" do
          # without http authorization header
          env = ::Rack::MockRequest.env_for(
            'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value')
          @request_from_sns = ::Rack::Request.new(env)

          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_verified?.should be_false
          @verifier.opensocial_oauth_skipped?.should be_false
        end
      end
      context "an oauth signed get request from sns" do
        it "must be verified" do
          env = ::Rack::MockRequest.env_for(
            'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
            'HTTP_AUTHORIZATION'=>http_oauth_header('GET'))
          @request_from_sns = ::Rack::Request.new(env)

          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_verified?.should be_true
          @verifier.opensocial_oauth_skipped?.should be_false
        end
        it "must be skipped" do
          env = ::Rack::MockRequest.env_for(
            'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
            'HTTP_AUTHORIZATION'=>http_oauth_header('GET'))
          @request_from_sns = ::Rack::Request.new(env)

          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
          skip_verification = true
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform, skip_verification
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_skipped?.should be_true
          @verifier.opensocial_oauth_verified?.should be_true
        end
        it "must be failed to verify" do
          env = ::Rack::MockRequest.env_for(
            'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
            'HTTP_AUTHORIZATION'=>http_oauth_header('GET'))
          @request_from_sns = ::Rack::Request.new(env)

          # invalid consumer secret
          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'foobar')
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_verified?.should be_false
          @verifier.opensocial_oauth_skipped?.should be_false
        end
      end
      context "a normal (oauth NOT signed) post request from sns" do
        it "must be failed to verify" do
          # without http authorization header
          env = ::Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
             :method=>'POST',
             :params=>{'post_sample_key'=>'post_sample_value'})
          @request_from_sns = ::Rack::Request.new(env)

          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_verified?.should be_false
          @verifier.opensocial_oauth_skipped?.should be_false
        end
      end
      context "an oauth signed post request from sns" do
        it "must be verified" do
          env = ::Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
             :method=>'POST',
             :params=>{'post_sample_key'=>'post_sample_value'}, 
             'HTTP_AUTHORIZATION'=>http_oauth_header('POST', {'post_sample_key'=>'post_sample_value'}))
          @request_from_sns = ::Rack::Request.new(env)

          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_verified?.should be_true
          @verifier.opensocial_oauth_skipped?.should be_false
        end
        it "must be skipped" do
          env = ::Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
             :method=>'POST',
             :params=>{'post_sample_key'=>'post_sample_value'}, 
             'HTTP_AUTHORIZATION'=>http_oauth_header('POST', {'post_sample_key'=>'post_sample_value'}))
          @request_from_sns = ::Rack::Request.new(env)

          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
          skip_verification = true
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform, skip_verification
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_skipped?.should be_true
          @verifier.opensocial_oauth_verified?.should be_true
        end
        it "must be failed to verify" do
          env = ::Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
             :method=>'POST',
             :params=>{'post_sample_key'=>'post_sample_value'}, 
             'HTTP_AUTHORIZATION'=>http_oauth_header('POST', {'post_sample_key'=>'post_sample_value'}))
          @request_from_sns = ::Rack::Request.new(env)

          # invalid consumer secret
          platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'foobar')
          @verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
          result = @verifier.verify @request_from_sns, nil
          result.should be_true
          @verifier.opensocial_oauth_verified?.should be_false
          @verifier.opensocial_oauth_skipped?.should be_false
        end
      end

      # generates an http authorization header using the specified parameters.
      def http_oauth_header method, params={}
        oauth_params = [
          "realm=\"\"",
          "oauth_nonce=\"0422e0b8f94c22dd8736\"",
          "oauth_signature_method=\"HMAC-SHA1\"",
          "oauth_timestamp=\"1295537417\"",
          "oauth_consumer_key=\"sample_consumer_key\"",
          "oauth_version=\"1.0\""]
          http_oauth_header = "OAuth " + oauth_params.join(', ')
        env = ::Rack::MockRequest.env_for(
          'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value',
          :method=>method, :params=>params,
          'HTTP_AUTHORIZATION'=>http_oauth_header)
        request = ::Rack::Request.new(env)
        request_proxy = OAuth::RequestProxy::RackRequest.new(request)
        opts = { :consumer_secret => 'sample_consumer_secret' }
        signature = ::OAuth::Signature.sign(request_proxy, opts)
        oauth_params.push "oauth_signature=\"#{OAuth::Helper.escape(signature)}\""
        http_oauth_header = "OAuth " + oauth_params.join(', ')
      end
    end
  end
end

