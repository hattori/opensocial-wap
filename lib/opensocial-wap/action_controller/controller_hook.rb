# -*- coding: utf-8 -*-

module ActionController
  class Base

    include ::OpensocialWap::Routing::UrlFor
    helper ::OpensocialWap::Helpers::UrlHelper
    helper ::OpensocialWap::Helpers::FormTagHelper
    helper ::OpensocialWap::Helpers::AssetTagHelper

    class_inheritable_accessor :opensocial_wap_enabled

    class << self

      # OpenSocial WAP Extension 用のURLを構築することを、コントローラに指定する.
      def opensocial_wap
        self.opensocial_wap_enabled = true

        app_config = Rails.application.config
        if app_config.respond_to?(:opensocial_wap)
          @url_setgings = app_config.opensocial_wap[:url] 
        end

        include ::OpensocialWap::ActionController::Redirecting    
      end

      def url_settings
        @url_setgings
      end
    end
  end
end
