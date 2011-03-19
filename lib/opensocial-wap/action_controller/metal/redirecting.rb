# -*- coding: utf-8 -*-

# ActionController::Redirecting を拡張.
module OpensocialWap
  module ActionController
    module Redirecting
      include ::OpensocialWap::Routing::UrlFor

      # Opensocial WAP Extension の URL設定中の　:redirect で指定した形式のURLにリダイレクトする.
      def redirect_to(options = {}, response_status = {})
        super
      end

      private
      
      # opensocial_wap[:url].redirect で指定した形式のURLを返す.
      def _compute_redirect_to_location(options)
        url = super
        url_settings = nil
        if (self.class.respond_to? :opensocial_wap_enabled) && (self.class.opensocial_wap_enabled == true)
          if self.class.url_settings
            url_settings = self.class.url_settings.redirect
          end
        end
        url_for(url, url_settings)
      end
    end
  end
end
