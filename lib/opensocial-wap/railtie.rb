# -*- coding: utf-8 -*-

require 'opensocial-wap/rack/opensocial_oauth'
require 'opensocial-wap/routing/url_for'
require 'opensocial-wap/helpers/base'
require 'opensocial-wap/helpers/url_helper'
require 'opensocial-wap/helpers/form_tag_helper'
require 'opensocial-wap/helpers/asset_tag_helper'
require 'opensocial-wap/action_controller/controller_hook'
require 'opensocial-wap/action_controller/metal/redirecting'
require 'opensocial-wap/session/opensocial_wap_sid'
require 'opensocial-wap/platform'
require 'opensocial-wap/platform/gree'
require 'opensocial-wap/platform/mixi'
require 'opensocial-wap/platform/mobage'

module OpensocialWap
  class Railtie < Rails::Railtie

    config.opensocial_wap = ActiveSupport::OrderedOptions.new

    initializer "opensocial-wap.initialize" do |app|
    end

    initializer 'opensocial-wap.load_middleware', :after=> :load_config_initializers do
      if config.opensocial_wap && config.opensocial_wap.oauth
        helper_class = config.opensocial_wap.oauth.helper_class
        
        if helper_class
          puts "opensocial-wap is enabled with #{helper_class}"
          config.app_middleware.insert_before ActionDispatch::Cookies, OpensocialWap::Rack::OpensocialOauth, :helper_class => helper_class
        else
          puts "opensocial-wap is NOT enabled"
        end
      end
    end
  end
end
