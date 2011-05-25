module OpensocialWap
  module Platform
    # Singleton Pattern
    extend self
    
    def mobage(config, &block)
      @config = config
      @sandbox = false
      instance_eval(&block)

      consumer_key    = @consumer_key
      consumer_secret = @consumer_secret
      app_id          = @app_id
      container_host  = @sandbox ? 'sb.pf.mbga.jp' : 'pf.mbga.jp'
      api_endpoint    = @sandbox ? 'http://sb.app.mbga.jp/api/restful/v1/' : "http://app.mbga.jp/api/restful/v1/"

      OpensocialWap::OAuth::Helpers::MobageHelper.configure do
        consumer_key    consumer_key
        consumer_secret consumer_secret
        api_endpoint    api_endpoint
        app_id          app_id
      end
      @config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.configure do
        helper_class OpensocialWap::OAuth::Helpers::MobageHelper
      end
      @config.opensocial_wap.url = OpensocialWap::Config::Url.configure do
        container_host container_host
        default        :format => :query, :params => { :guid => 'ON' }
        redirect       :format => :local
        public_path    :format => :local
      end
      @config.opensocial_wap.session_id = @session ? :parameter : :cookie
    end
  end
end
