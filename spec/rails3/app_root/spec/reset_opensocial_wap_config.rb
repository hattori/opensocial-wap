def reset_opensocial_wap_config(config)
  config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.configure do
    OpensocialWap::OAuth::Helpers::BasicHelper.configure do
      proxy_class     OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxy
      consumer_key    'abcdef'
      consumer_secret 'abcdefg12345'
      api_endpoint    'http://api.example.com/'
    end
    helper_class OpensocialWap::OAuth::Helpers::BasicHelper
  end

  config.opensocial_wap.url = OpensocialWap::Config::Url.configure do
    default     :format => :full, :container_host => 'container.example.com', :params => { :guid => 'ON' }
    redirect    :format => :query, :params => { :guid => 'ON' }
    public_path :format => :plain
  end
  config.opensocial_wap.session_id = :parameter
end
