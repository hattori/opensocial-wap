# -*- coding: utf-8 -*-

module ActionController
  class Base

    include ::OpensocialWap::Routing::UrlFor
    helper ::OpensocialWap::Helpers::UrlHelper
    helper ::OpensocialWap::Helpers::FormTagHelper

    DEFAULT_OPENSOCIAL_WAP_URL_OPTIONS = { :url_format => nil, :params => {} }.freeze
    class_inheritable_accessor :opensocial_wap_enabled

    class << self

      # OpenSocial WAP Extension 用のURLを構築することを、コントローラに指定する.
      def opensocial_wap(options = {})
        self.opensocial_wap_enabled = true
        init_opensocoal_wap_options(options)
        
        include ::OpensocialWap::ActionController::Redirecting    
      end

      def opensocial_wap_options
        @opensocial_wap_options ||= init_opensocoal_wap_options
      end

      # イニシャライザでの OpenSocial WAP Extension 設定に、コントローラ毎設定をマージして、
      # クラスインスタンス変数にセットする.
      def init_opensocoal_wap_options(options = nil)
        @opensocial_wap_options = DEFAULT_OPENSOCIAL_WAP_URL_OPTIONS.dup
        # アプリケーション初期化時に、Application#config にセットした設定をマージ.
        app_config = Rails.application.config
        if app_config.respond_to?(:opensocial_wap)
          @opensocial_wap_options.merge!(app_config.opensocial_wap.url_options || {}) 
        end
        # コントローラレベルでの設定をマージ.
        if options
          @opensocial_wap_options.merge!(options)
        end
        @opensocial_wap_options
      end
    end
  end
end
