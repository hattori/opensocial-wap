# -*- coding: utf-8 -*-

module OpensocialWap
  module Helpers
    module Base

      # イニシャライザで設定したURL生成オプションを取得して返す.
      def default_url_settings
        if controller.class.respond_to? 'url_settings'
          controller.class.url_settings
        else
          nil
        end
      end
    end
  end
end
