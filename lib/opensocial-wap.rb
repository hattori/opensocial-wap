require 'opensocial-wap/routing/url_formatter.rb'
require 'opensocial-wap/verifiers/opensocial_verifier.rb'
require 'opensocial-wap/rack/opensocial_oauth.rb'
require 'opensocial-wap/rack/request.rb'

if defined?(::Rails::Railtie)
  require 'opensocial-wap/railtie'
end

module OpensocialWap
end
