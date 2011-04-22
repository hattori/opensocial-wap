module OpensocialWap
  class Platform

    def gree(&block)
      @sandbox = false
      instance_eval(&block)
      setup_gree
    end

    def sandbox(sandbox = true)
      @sandbox = sandbox
    end

    private

    # Setup the configuration for GREE.
    def setup_gree
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

    def container_host
      @sandbox ? 'mgadget-sb.gree.jp' : "mgadget.gree.jp"
    end

    def api_endpoint
      @sandbox ? 'http://os-sb.gree.jp/api/rest/' : "http://os.gree.jp/api/rest/"
    end

  end
end
