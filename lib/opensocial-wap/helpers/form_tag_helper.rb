# -*- coding: utf-8 -*-

# ActionView::Helpers::FormTagHelper を拡張.
# form_for は実装の内部で form_tag を呼び出しているので、ここで行った変更は form_for にも波及する.
module OpensocialWap
  module Helpers
    module FormTagHelper
      include Base

      # Rails オリジナル実装の form_tag と同じ.
      # ただし、options ハッシュに、:osw_options ハッシュを渡すことができる.
      # osw_options の優先順位は、options ハッシュ > コントローラで指定した値 > イニシャライザで指定した値.
      #
      # == 例
      # form_tag('/posts', :osw_options => {:url_format=>:query})
      # # => <form action="?=url....." method="post">
      # 
      def form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
        super
      end

      private
      
      # form_tag のHTMLオプションを計算する.
      def html_options_for_form(url_for_options, options, *parameters_for_url)
        options.stringify_keys.tap do |html_options|
debugger
          html_options["enctype"] = "multipart/form-data" if html_options.delete("multipart")
          # ows_options を、options から取り出す.
          osw_options = extract_osw_options(html_options)

          # The following URL is unescaped, this is just a hash of options, and it is the
          # responsability of the caller to escape all the values.
          #html_options["action"]  = url_for(url_for_options, *parameters_for_url)
          html_options["action"]  = url_for(url_for_options, osw_options)
          html_options["accept-charset"] = "UTF-8"
          html_options["data-remote"] = true if html_options.delete("remote")
        end
      end

      private

      # html_options から Opensocial WAP用オプションを取り出す.
      def extract_osw_options(html_options)
        if html_options
          osw_options = html_options.delete("opensocial_wap")
        end
        # コントローラで opensocial_wap が呼ばれていれば、osw_options を有効にする.
        if controller.class.opensocial_wap_enabled
          osw_options ||= {}
        end
        osw_options
      end
    end
  end
end
