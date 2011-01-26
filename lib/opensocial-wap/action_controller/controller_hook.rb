module ActionController
  class Base

    class_inheritable_accessor :opensocial_wap_options

    class << self
      def opensocial_wap(options)
        self.opensocial_wap_options = {:url_format => nil, :params => {}}.merge(options || {})
        include ::OpensocialWap::Routing::UrlFor
        include ::OpensocialWap::ActionController::Redirecting
        helper ::OpensocialWap::Helpers::UrlHelper
        helper ::OpensocialWap::Helpers::FormTagHelper
      end
    end
  end
end
