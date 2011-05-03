module OpensocialWap
  module Platform
    extend self

    def mixi(config, &block)
      @config = config
      @access_from_pc = false
      instance_eval(&block)

      container_host = @access_from_pc ? 'ma.test.mixi.net' : 'ma.mixi.net'

      @config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.new do |config|
        options = {
          :proxy_class => ::OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxyForMixi,
          :consumer_key => @consumer_key,
          :consumer_secret => @consumer_secret,
          :api_endpoint => 'http://api.mixi-platform.com/os/0.8/',
        }
        config.helper_class OpensocialWap::OAuth::Helpers::BasicHelper.setup(options)
      end
      @config.opensocial_wap.url = OpensocialWap::Config::Url.new do |config|
        config.default     :format => :query, :params => { :guid => 'ON' }
        config.redirect    :format => :full, :container_host => container_host, :params => { :guid => 'ON' }
        config.public_path :format => :local
      end
      @config.opensocial_wap.session_id = @session ? :parameter : :cookie
    end

    def access_from_pc(access_from_pc = true)
      @access_from_pc = access_from_pc
    end
  end
end
