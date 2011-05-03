module OpensocialWap
  module Platform
    extend self

    def gree(config, &block)
      configure(config)
      @sandbox = false
      instance_eval(&block)

      container_host = @sandbox ? 'mgadget-sb.gree.jp' : "mgadget.gree.jp"
      api_endpoint = @sandbox ? 'http://os-sb.gree.jp/api/rest/' : "http://os.gree.jp/api/rest/"

      @config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.new do |config|
        options = {
          :consumer_key => @consumer_key,
          :consumer_secret => @consumer_secret,
          :api_endpoint => api_endpoint,
        }
        config.helper_class OpensocialWap::OAuth::Helpers::BasicHelper.setup(options)
      end
      @config.opensocial_wap.url = OpensocialWap::Config::Url.new do |config|
        config.default     :format => :query, :params => { :guid => 'ON' }
        config.redirect    :format => :local
        config.public_path :format => :local
      end
      @config.opensocial_wap.session_id = @session ? :parameter : :cookie
    end
  end
end
