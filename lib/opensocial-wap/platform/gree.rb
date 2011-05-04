module OpensocialWap
  module Platform
    # Singleton Pattern
    extend self

    def gree(config, &block)
      configure(config)
      @sandbox = false
      instance_eval(&block)

      consumer_key    = @consumer_key
      consumer_secret = @consumer_secret
      container_host  = @sandbox ? 'mgadget-sb.gree.jp' : "mgadget.gree.jp"
      api_endpoint    = @sandbox ? 'http://os-sb.gree.jp/api/rest/' : "http://os.gree.jp/api/rest/"

      OpensocialWap::OAuth::Helpers::BasicHelper.configure do
        consumer_key    consumer_key
        consumer_secret consumer_secret
        api_endpoint    api_endpoint
      end
      @config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.configure do
        helper_class OpensocialWap::OAuth::Helpers::BasicHelper
      end
      @config.opensocial_wap.url = OpensocialWap::Config::Url.configure do
        default     :format => :query, :params => { :guid => 'ON' }
        redirect    :format => :local
        public_path :format => :local
      end
      @config.opensocial_wap.session_id = @session ? :parameter : :cookie
    end
  end
end
