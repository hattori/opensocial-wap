require 'opensocial-wap/opensocial_verifier.rb'
require 'opensocial-wap/rack/opensocial_oauth.rb'

if defined?(::Rails::Railtie)
  require 'opensocial-wap/railtie'
end

module OpensocialWap
end
