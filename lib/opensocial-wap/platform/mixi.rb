module OpensocialWap
  module Platform
    # Singleton Pattern
    extend self

    def mixi(config, &block)
      @config = config
      @access_from_pc = false
      instance_eval(&block)

      consumer_key    = @consumer_key
      consumer_secret = @consumer_secret
      container_host  = @access_from_pc ? 'ma.test.mixi.net' : 'ma.mixi.net'

      OpensocialWap::OAuth::Helpers::BasicHelper.configure do
        proxy_class     OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxyForMixi
        consumer_key    consumer_key
        consumer_secret consumer_secret
        api_endpoint    'http://api.mixi-platform.com/os/0.8/'
      end
      @config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.configure do
        helper_class OpensocialWap::OAuth::Helpers::BasicHelper
      end
      @config.opensocial_wap.url = OpensocialWap::Config::Url.configure do
        container_host container_host
        default        :format => :query, :params => { :guid => 'ON' }
        redirect       :format => :full, :params => { :guid => 'ON' }
        public_path    :format => :local
      end
      @config.opensocial_wap.session_id = @session ? :parameter : :cookie
    end

    def access_from_pc(access_from_pc = true)
      @access_from_pc = access_from_pc
    end
  end
end
