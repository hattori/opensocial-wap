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

module OpensocialWap
  class Railtie < Rails::Railtie

    config.opensocial_wap = ActiveSupport::OrderedOptions.new

    initializer "opensocial-wap.initialize" do |app|
      # do something..
    end

    initializer 'opensocial-wap.load_middleware', :after=> :load_config_initializers do
      verifier = config.opensocial_wap[:verifier] 
      log_level = config.opensocial_wap[:log_level] || Logger::ERROR

      if verifier
        puts "opensocial-wap is enabled with #{verifier.class}"
        config.app_middleware.insert_before ActionDispatch::Cookies, OpensocialWap::Rack::OpensocialOauth, :verifier=> verifier, :log_level => log_level
      else
        puts "opensocial-wap is NOT enabled" 
      end
    end

  end
end
