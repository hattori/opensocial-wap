# -*- coding: utf-8 -*-

# ActionController::Redirecting を拡張.
module OpensocialWap
  module ActionController
    module Redirecting
      include ::OpensocialWap::Routing::UrlFor

      # Opensocial WAP Extension の URL設定中の　:redirect_url_format で指定した形式のURLにリダイレクトする.
      def redirect_to(options = {}, response_status = {})
        super
      end

      private
      
      # :redirect_url_format で指定した形式のURLを返す.
      def _compute_redirect_to_location(options)
        url = super
        if (self.class.respond_to? :opensocial_wap_enabled) && (self.class.opensocial_wap_enabled == true)
          osw_options = self.class.opensocial_wap_options.dup
          redirect_url_format = osw_options[:redirect_url_format]
          if redirect_url_format
            osw_options[:url_format] = redirect_url_format
          end
        end
        url_for(url, osw_options)
      end
    end
  end
end
