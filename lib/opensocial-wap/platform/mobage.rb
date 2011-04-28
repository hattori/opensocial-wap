module OpensocialWap
  class Platform

    def mobage(&block)
      @sandbox = false
      instance_eval(&block)
      setup_mobage
    end

    def sandbox(sandbox = true)
      @sandbox = sandbox
    end

    def app_id(app_id)
      @app_id = app_id
    end

    private

    # Setup the configuration for mobage.
    def setup_mobage
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

    def container_host
      @sandbox ? 'sb.pf.mbga.jp' : 'pf.mbga.jp'
    end

    def api_endpoint
      @sandbox ? 'http://sb.app.mbga.jp/api/restful/v1/' : "http://app.mbga.jp/api/restful/v1/"
    end

  end
end
