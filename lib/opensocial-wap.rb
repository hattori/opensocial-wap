require 'opensocial-wap/opensocial_platform.rb'
require 'opensocial-wap/rack/opensocial_oauth.rb'

if defined?(::Rails::Railtie)
  require 'opensocial-wap/routing/url_for'
  require 'opensocial-wap/helpers/base'
  require 'opensocial-wap/helpers/url_helper'
  require 'opensocial-wap/helpers/form_tag_helper'
  require 'opensocial-wap/helpers/form_helper'
end

module OpensocialWap
end
