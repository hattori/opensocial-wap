# Rack middleware for test.
# 
# Force env['opensocial-wap.rack']['OPENSOCIAL_OAUTH_VERIFIED'] to true if config.opensocial_wap_sid_enabled is true.
class OpensocialWapSidEnabler
  def initialize(app)
    @app = app
  end
  
  def call(env)
    config = Rails.application.config
    if (config.respond_to? :enable_opensocial_wap_sid) && config.enable_opensocial_wap_sid
      env['opensocial-wap.rack']['OPENSOCIAL_OAUTH_VERIFIED'] = true
    end

    if (config.respond_to? :opensocial_wap_sid_with_parameter) && config.opensocial_wap_sid_with_parameter
      params = config.opensocial_wap_sid_with_parameter.map {|k, v| "#{k}=#{v}"}.join("&")
      if env['QUERY_STRING'].present? && params.present?
        env['QUERY_STRING'] += "&"
      end
      env['QUERY_STRING'] += params
    end
    status, headers, response = @app.call(env)
    [status, headers, response]
  end
end
