# -*- coding: utf-8 -*-

module ActionController
  class Base

    DEFAULT_OPENSOCIAL_WAP_URL_OPTIONS = { :url_format => nil, :params => {} }.freeze
    class_inheritable_accessor :opensocial_wap_options

    class << self

      # OpenSocial WAP Extension 用のURLを構築することを、コントローラに指定する.
      def opensocial_wap(options = {})
        self.opensocial_wap_options = DEFAULT_OPENSOCIAL_WAP_URL_OPTIONS.dup
        # アプリケーション初期化時に、Application#config にセットした設定をマージ.
        app_config = Rails.application.config
        if app_config.respond_to?(:opensocial_wap)
          self.opensocial_wap_options.merge!(app_config.opensocial_wap.url_options || {}) 
        end
        # コントローラレベルでの設定をマージ.
        self.opensocial_wap_options.merge!(options || {})

        include ::OpensocialWap::Routing::UrlFor
        include ::OpensocialWap::ActionController::Redirecting
        helper ::OpensocialWap::Helpers::UrlHelper
        helper ::OpensocialWap::Helpers::FormTagHelper
      end
    end
  end
end
