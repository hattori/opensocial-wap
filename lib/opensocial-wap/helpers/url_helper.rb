# -*- coding: utf-8 -*-

# ActionView::Helpers::UrlHelper を拡張.
module OpensocialWap
  module Helpers
    module UrlHelper
      include ::OpensocialWap::Routing::UrlFor
      include Base

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

      # link_to for the OpenSocial WAP Extension.
      # 
      # イニシャライザ、コントローラでの設定に基づいて、OpenSocial WAP用URLをセットする.
      # html_options引数に、:opensocial_wap というキーで、osw_options の設定を上書きすることができる.
      # なお、link_to_if, link_to_unless, link_to_unless_current にも本拡張の影響は及ぶ(内部で link_to を呼んでいるため).
      def link_to(*args, &block)
        if block_given?
          options      = args.first || {}
          html_options = args.second
          link_to(capture(&block), options, html_options, osw_options)
        else
          name         = args[0]
          options      = args[1] || {}
          html_options = args[2]

          html_options = convert_options_to_data_attributes(options, html_options)
          osw_options = extract_osw_options(html_options)

          url = url_for(options, osw_options) # osw_options 引数付きで url_for 呼び出し.
          href = html_options['href']
          tag_options = tag_options(html_options)
          
          href_attr = "href=\"#{html_escape(url)}\"" unless href
          "<a #{href_attr}#{tag_options}>#{html_escape(name || url)}</a>".html_safe
        end
      end
      
      # button_to for the OpenSocial WAP Extension.
      #
      # イニシャライザ、コントローラでの設定に基づいて、OpenSocial WAP用URLをセットする.
      # html_options引数に、:opensocial_wap というキーで、osw_options の設定を上書きすることができる.
      def button_to(name, options = {}, html_options = {})
        html_options = html_options.stringify_keys
        convert_boolean_attributes!(html_options, %w( disabled ))
        
        method_tag = ''
        if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
          method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
        end
        
        form_method = method.to_s == 'get' ? 'get' : 'post'
        
        remote = html_options.delete('remote')
        
        request_token_tag = ''
        if form_method == 'post' && protect_against_forgery?
          request_token_tag = tag(:input, 
                                  :type => "hidden", 
                                  :name => request_forgery_protection_token.to_s, 
                                  :value => form_authenticity_token)
        end

        osw_options = extract_osw_options(html_options)

        url = url_for(options, osw_options)
        name ||= url
        
        html_options = convert_options_to_data_attributes(options, html_options)
        
        html_options.merge!("type" => "submit", "value" => name)
        
        ("<form method=\"#{form_method}\" action=\"#{html_escape(url)}\" #{"data-remote=\"true\"" if remote} class=\"button_to\"><div>" +
         method_tag + tag("input", html_options) + request_token_tag + "</div></form>").html_safe
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

