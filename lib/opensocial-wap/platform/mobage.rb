module OpensocialWap
  module Platform
    extend self
    
    def mobage(config, &block)
      @config = config
      @sandbox = false
      instance_eval(&block)

      container_host = @sandbox ? 'sb.pf.mbga.jp' : 'pf.mbga.jp'
      api_endpoint = @sandbox ? 'http://sb.app.mbga.jp/api/restful/v1/' : "http://app.mbga.jp/api/restful/v1/"

      @config.opensocial_wap.oauth = OpensocialWap::Config::OAuth.new do |config|
        options = {
          :consumer_key => @consumer_key,
          :consumer_secret => @consumer_secret,
          :api_endpoint => api_endpoint,
          :app_id => @app_id
        }
        config.helper_class OpensocialWap::OAuth::Helpers::MobageHelper.setup(options)
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
