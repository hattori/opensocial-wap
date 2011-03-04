# -*- coding: utf-8 -*-

module OpensocialWap
  module Helpers
    module Base

      # Retrieves the options for url generation from the corresponding controller.
      #
      # イニシャライザもしくはコントローラで設定したURL生成オプションを取得して返す.
      def default_osw_options
        if controller.class.respond_to? 'opensocial_wap_options'
          controller.class.opensocial_wap_options || {}
        else
          nil
        end
      end
    end
  end
end
