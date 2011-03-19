# -*- coding: utf-8 -*-

# ActionView::Helpers::FormTagHelper を拡張.
# form_for は実装の内部で form_tag を呼び出しているので、ここで行った変更は form_for にも波及する.
module OpensocialWap
  module Helpers
    module FormTagHelper
      include UrlHelper

      # Rails オリジナル実装の form_tag と同じ.
      # ただし、options ハッシュに、:url_settings をキーにした値を渡すことができる.
      # url_settings の優先順位は、options ハッシュ > イニシャライザで指定した値.
      #
      # == 例
      # form_tag('/posts', :url_settings => {:format=>:query})
      # # => <form action="?=url....." method="post">
      # 
      def form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
        super
      end

      private
      
      # form_tag のHTMLオプションを計算する.
      def html_options_for_form(url_for_options, options, *parameters_for_url)
        # Jpmobileとの互換性のため、accept_charset を変更できるように.
        accept_charset = "UTF-8"
        if defined?(::Jpmobile)
          accept_charset = (Rails.application.config.jpmobile.form_accept_charset_conversion && request && request.mobile && request.mobile.default_charset)
        end

        options.stringify_keys.tap do |html_options|
          html_options["enctype"] = "multipart/form-data" if html_options.delete("multipart")
          # url_settings を、options から取り出す.
          url_settings = extract_url_settings(html_options)

          # The following URL is unescaped, this is just a hash of options, and it is the
          # responsability of the caller to escape all the values.
          #html_options["action"]  = url_for(url_for_options, *parameters_for_url)
          html_options["action"]  = url_for(url_for_options, url_settings)
          html_options["accept-charset"] = accept_charset
          html_options["data-remote"] = true if html_options.delete("remote")
        end
      end

      private

      # html_options から Opensocial WAP用オプションを取り出す.
      def extract_url_settings(html_options)
        url_settings = nil
        if html_options
          url_settings = html_options.delete("url_settings")
        end
        if !url_settings && default_url_settings
          # コントローラで opensocial_wap が呼ばれていれば、url_settings を有効にする.
          # form_tag 系では、:default の設定を使用する.
          url_settings = default_url_settings.default
        end
        url_settings
      end
    end
  end
end
