# -*- coding: utf-8 -*-

module OpensocialWap
  module Helpers
    module Base

      # Retrieves the options for url generation from the corresponding controller.
      def default_osw_options
        if controller.respond_to? 'opensocial_wap_options'
          controller.opensocial_wap_options || {}
        else
          nil
        end
      end

    end
  end
end
