# -*- coding: utf-8 -*-

# ActionView::Helpers::AssetTagHelper を拡張.
module OpensocialWap
  module Helpers
    module AssetTagHelper
      include UrlHelper
      
      # コントローラ内もしくは初期化時に、:public_path_format が指定されていれば、パスを
      # OpenSocial 用のものに書き換える.
      def compute_public_path(source)
        path = super
        osw_options = default_osw_options
        if osw_options[:public_path_format]
          osw_options[:url_format] = osw_options[:public_path_format]
          path = url_for(path, osw_options)
        end
        path
      end
    end
  end
end
