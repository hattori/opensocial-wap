# -*- coding: utf-8 -*-

module OpensocialWap
  module Helpers
    module Base
      include ::OpensocialWap::Routing::UrlFor

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

      # url_for for the OpenSocial WAP Extension.
      #
      # ows_options 引数が nil か false である場合、本来の実装による url_for を実行する.
      #
      # osw_options 引数に有効な値が指定されていれば、拡張 url_for を呼び出す.
      # osw_options は、下記の場所で指定することができる.
      # * url_for の osw_options 引数.
      # * コントローラの opensocial_wap クラスメソッドの引数中の、:opensocial_wapに対する値.
      # * Rails.application.config.opensocial_wap.url_options の値(初期化時に指定).
      # 優先順位は上の方が高い.
      # 
      def url_for(options = {}, osw_options = nil)
        unless osw_options
          return super(options) # 本来の実装.
        end
        options ||= {}
        osw_options = default_osw_options.merge(osw_options) # controller で指定したオプションを引数で上書き.
        case options
        when :back
          controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
        else
          # OpensocialWap::Routing::UrlFor の url_for を呼び出す.
          super(options, osw_options)
        end        
      end

    end
  end
end
