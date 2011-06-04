# -*- coding: utf-8 -*-

module ActionController
  class Base

    include ::OpensocialWap::Routing::UrlFor
    helper ::OpensocialWap::Helpers::UrlHelper
    helper ::OpensocialWap::Helpers::FormTagHelper
    helper ::OpensocialWap::Helpers::AssetTagHelper

    class_attribute :opensocial_wap_enabled
    class_attribute :url_settings

    class << self

      # OpenSocial WAP Extension 用のURLを構築することを、コントローラに指定する.
      def opensocial_wap
        self.opensocial_wap_enabled = true

        app_config = Rails.application.config
        if app_config.respond_to?(:opensocial_wap)
          self.url_settings = app_config.opensocial_wap[:url]
        end

        include OpensocialWap::ActionController::Redirecting    
      end
    end
  end
end
