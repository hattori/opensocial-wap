module OpensocialWap
  module ActionController
    module Redirecting
      include ::OpensocialWap::Routing::UrlFor

      def redirect_to(options = {}, response_status = {})
        super
      end

      private
      
      # 
      def _compute_redirect_to_location(options)
        url = super
        osw_options = self.opensocial_wap_options
        redirect_url_format = osw_options[:redirect_url_format] || :full
        
        case redirect_url_format
        when :plain
          url
        when :query
          query_url_for(url, osw_options[:params])
        else
          full_url_for(url, osw_options, params[:opensocial_app_id])
        end
      end
    end
  end
end
