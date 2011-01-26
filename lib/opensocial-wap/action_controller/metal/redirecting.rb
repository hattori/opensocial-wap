module OpensocialWap
  module ActionController
    module Redirecting
      include ::OpensocialWap::Routing::UrlFor

      private
      
      # 
      def _compute_redirect_to_location(options)
        url = super
        full_url_for(url, self.opensocial_wap_options, params[:opensocial_app_id])
      end
    end
  end
end
