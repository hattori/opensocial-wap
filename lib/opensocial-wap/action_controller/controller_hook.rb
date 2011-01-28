# -*- coding: utf-8 -*-

module ActionController
  class Base

    DEFAULT_OPENSOCIAL_WAP_URL_OPTIONS = { :url_format => nil, :params => {} }.freeze
    class_inheritable_accessor :opensocial_wap_options

    class << self
      def opensocial_wap(options = {})
        self.opensocial_wap_options = DEFAULT_OPENSOCIAL_WAP_URL_OPTIONS.dup
        # アプリケーション初期化時に、Application#config にセットした設定をマージ.
        if Rails.application.config.respond_to?(:opensocial_wap)
          self.opensocial_wap_options.merge!(Rails.application.config.opensocial_wap[:url_options] || {}) 
        end
        # コントローラレベルでの設定をマージ.
        self.opensocial_wap_options.merge(options || {})

        include ::OpensocialWap::Routing::UrlFor
        include ::OpensocialWap::ActionController::Redirecting
        helper ::OpensocialWap::Helpers::UrlHelper
        helper ::OpensocialWap::Helpers::FormTagHelper
      end
    end
  end
end
