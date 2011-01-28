# -*- coding: utf-8 -*-

require 'opensocial-wap/routing/url_for'
require 'opensocial-wap/helpers/base'
require 'opensocial-wap/helpers/url_helper'
require 'opensocial-wap/helpers/form_tag_helper'
require 'opensocial-wap/action_controller/controller_hook'
require 'opensocial-wap/action_controller/metal/redirecting'

module OpensocialWap
  class Railtie < Rails::Railtie
    initializer "opensocial-wap.initialize" do |app|
      # do something..
      config.app_middleware.insert_before(ActionDispatch::Cookies, Rails::Rack::Debugger)
    end
  end
end
