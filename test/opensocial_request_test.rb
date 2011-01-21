require File.expand_path('../test_helper', __FILE__)

class OpensocialRequestTest < Test::Unit::TestCase

  def test_get_request_without_auth
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value')
    request_from_sns = ::Rack::Request.new(env)

    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
    result = verifier.verify request_from_sns, nil
    assert_equal result, true
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal false, rack_request.opensocial_oauth_skipped? 
    assert_equal false, rack_request.opensocial_oauth_verified?
    assert_equal '877', rack_request.params['opensocial_app_id']
    assert_equal '23', rack_request.params['opensocial_owner_id']
    assert_equal 'sample_value', rack_request.params['sample_key']
  end

  def test_get_request_with_auth
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
                                    'HTTP_AUTHORIZATION'=>http_oauth_header('GET'))
    request_from_sns = ::Rack::Request.new(env)

    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
    result = verifier.verify request_from_sns, nil
    assert_equal result, true 
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal false, rack_request.opensocial_oauth_skipped?
    assert_equal true, rack_request.opensocial_oauth_verified?
    assert_equal '877', rack_request.params['opensocial_app_id']
    assert_equal '23', rack_request.params['opensocial_owner_id']
    assert_equal 'sample_value', rack_request.params['sample_key']
  end

  def test_get_request_with_auth_failure
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
                                    'HTTP_AUTHORIZATION'=>http_oauth_header('GET'))
    request_from_sns = ::Rack::Request.new(env)

    # invalid consumer secret
    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'foobar')
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
    result = verifier.verify request_from_sns, nil
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal false, rack_request.opensocial_oauth_skipped?
    assert_equal false, rack_request.opensocial_oauth_verified?
  end

  def test_get_request_skipping_auth
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
                                    'HTTP_AUTHORIZATION'=>http_oauth_header('GET'))
    request_from_sns = ::Rack::Request.new(env)

    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
    skip_verification = true
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform, skip_verification 
    result = verifier.verify request_from_sns, nil
    assert_equal result, true 
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal true, rack_request.opensocial_oauth_skipped?
    assert_equal true, rack_request.opensocial_oauth_verified?
    assert_equal '877', rack_request.params['opensocial_app_id']
    assert_equal '23', rack_request.params['opensocial_owner_id']
    assert_equal 'sample_value', rack_request.params['sample_key']
  end

  def test_post_request_with_auth
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
                                    :method=>'POST',:params=>{'post_sample_key'=>'post_sample_value'}, 'HTTP_AUTHORIZATION'=>http_oauth_header('POST', {'post_sample_key'=>'post_sample_value'}))
    request_from_sns = ::Rack::Request.new(env)

    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
    result = verifier.verify request_from_sns, nil
    assert_equal result, true 
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal false, rack_request.opensocial_oauth_skipped?
    assert_equal true, rack_request.opensocial_oauth_verified?
    assert_equal '877', rack_request.params['opensocial_app_id']
    assert_equal '23', rack_request.params['opensocial_owner_id']
    assert_equal 'sample_value', rack_request.params['sample_key']
  end

  def test_post_request_with_auth_failure
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
                                    :method=>'POST',:params=>{'post_sample_key'=>'post_sample_value'}, 'HTTP_AUTHORIZATION'=>http_oauth_header('POST', {'post_sample_key'=>'post_sample_value'}))
    request_from_sns = ::Rack::Request.new(env)
   
    # invalid consumer secret
    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'foobar')
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform
    result = verifier.verify request_from_sns, nil
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal false, rack_request.opensocial_oauth_skipped?
    assert_equal false, rack_request.opensocial_oauth_verified?
  end

  def test_post_request_skipping_auth
    env = Rack::MockRequest.env_for('http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
                                    :method=>'POST',:params=>{'post_sample_key'=>'post_sample_value'}, 'HTTP_AUTHORIZATION'=>http_oauth_header('POST', {'post_sample_key'=>'post_sample_value'}))
    request_from_sns = ::Rack::Request.new(env)

    platform = OpensocialWap::OpensocialPlatform.new(:consumer_key=>'sample_consumer_key', :consumer_secret=>'sample_consumer_secret')
    skip_verification = true
    verifier = OpensocialWap::Rack::OpensocialOauthVerifier.new platform, skip_verification
    result = verifier.verify request_from_sns, nil
    assert_equal result, true 
    rack_request = ::Rack::Request.new(request_from_sns.env)
    assert_equal true, rack_request.opensocial_oauth_skipped?
    assert_equal true, rack_request.opensocial_oauth_verified?
    assert_equal '877', rack_request.params['opensocial_app_id']
    assert_equal '23', rack_request.params['opensocial_owner_id']
    assert_equal 'sample_value', rack_request.params['sample_key']
  end

  private

  def http_oauth_header method, params={}
    oauth_params = [
      "realm=\"\"",
      "oauth_nonce=\"0422e0b8f94c22dd8736\"", 
      "oauth_signature_method=\"HMAC-SHA1\"", 
      "oauth_timestamp=\"1295537417\"", 
      "oauth_consumer_key=\"sample_consumer_key\"", 
      "oauth_version=\"1.0\""]
    http_oauth_header = "OAuth " + oauth_params.join(', ')
    env = Rack::MockRequest.env_for(
      'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value', 
      :method=>method, :params=>params, 
      'HTTP_AUTHORIZATION'=>http_oauth_header)
    request = Rack::Request.new(env)
    request_proxy = OAuth::RequestProxy::RackRequest.new(request)
    opts = { :consumer_secret => 'sample_consumer_secret' }
    signature = OAuth::Signature.sign(request_proxy, opts)
    oauth_params.push "oauth_signature=\"#{OAuth::Helper.escape(signature)}\""
    http_oauth_header = "OAuth " + oauth_params.join(', ')
  end

end

