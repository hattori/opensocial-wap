module OpensocialWap
  class Platform

    def mixi(&block)
      instance_eval(&block)
      setup_mixi
    end

    def sandbox(sandbox = true)
      @sandbox = sandbox
    end

    private

    # Setup the configuration for mixi.
    def setup_mixi
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
        config.redirect    :format => :full, :container_host => 'ma.test.mixi.net', :params => { :guid => 'ON' }
        config.public_path :format => :local
      end
      @config.opensocial_wap.session_id = @session ? :parameter : :cookie
    end
  end
end
