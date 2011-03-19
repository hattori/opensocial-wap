# -*- coding: utf-8 -*-

# ActionView::Helpers::AssetTagHelper を拡張.
module OpensocialWap
  module Helpers
    module AssetTagHelper
      include UrlHelper
      include ::ActionView::Helpers::AssetTagHelper
      
      # compute_public_path を上書き.
      # 初期化時に、opensocial_wap[:url] でURL形式が指定されていれば、パスを
      # OpenSocial 用のものに書き換える.
      def compute_public_path(source, dir, ext = nil, include_host = true)
        path = super
        if default_url_settings
          # public_path で指定されているオプションを使用する.
          url_settings = default_url_settings.public_path
          path = url_for(path, url_settings)
        end
        path
      end
    end
  end
end
