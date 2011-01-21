# -*- coding: utf-8 -*-

require 'opensocial-wap/routing/url_for'
require 'opensocial-wap/helpers/base'
require 'opensocial-wap/helpers/url_helper'
require 'opensocial-wap/helpers/form_tag_helper'
require 'opensocial-wap/helpers/form_helper'

module OpensocialWap
  class Railtie < Rails::Railtie
    initializer "opensocial-wap.initialize" do |app|
      puts 'opensocial-wap initialized.'
    end
  end
end
