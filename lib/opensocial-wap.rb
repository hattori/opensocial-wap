require 'opensocial-wap/url_formatter.rb'
require 'opensocial-wap/opensocial_verifier.rb'
require 'opensocial-wap/rack/opensocial_oauth.rb'
require 'opensocial-wap/rack/request.rb'
require 'opensocial-wap/rack/logger.rb'

if defined?(::Rails::Railtie)
  require 'opensocial-wap/railtie'
end

module OpensocialWap
end
