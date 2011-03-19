# -*- coding: utf-8 -*-

# ActionView::Helpers::UrlHelper を拡張.
module OpensocialWap
  module Helpers
    module UrlHelper
      include ::OpensocialWap::Routing::UrlFor
      include Base

      # url_for for the OpenSocial WAP Extension.
      #
      # url_settings 引数が nil か false である場合、本来の実装による url_for を実行する.
      #
      # url_settings 引数に有効な値が指定されていれば、拡張 url_for を呼び出す.
      # url_settings は、下記の場所で指定することができる.
      # * url_for の url_settings 引数.
      # * Rails.application.config.opensocial_wap[:url] の値(初期化時に指定).
      # 優先順位は上の方が高い.
      # 
      def url_for(options = {}, url_settings = nil)
        unless url_settings
          return super(options) # 本来の実装.
        end
        options ||= {}
        case options
        when :back
          controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
        else
          # OpensocialWap::Routing::UrlFor の url_for を呼び出す.
          super(options, url_settings)
        end        
      end

      # link_to for the OpenSocial WAP Extension.
      # 
      # イニシャライザ、コントローラでの設定に基づいて、OpenSocial WAP用URLをセットする.
      # html_options引数に、:url_settings というキーで値を指定して、URL書き換え設定を上書きすることができる.
      # なお、link_to_if, link_to_unless, link_to_unless_current にも本拡張の影響は及ぶ(内部で link_to を呼んでいるため).
      def link_to(*args, &block)
        if block_given?
          options      = args.first || {}
          html_options = args.second
          link_to(capture(&block), options, html_options)
        else
          name         = args[0]
          options      = args[1] || {}
          html_options = args[2]

          html_options = convert_options_to_data_attributes(options, html_options)
          url_settings = extract_url_settings(html_options)

          url = url_for(options, url_settings) # url_settings 引数付きで url_for 呼び出し.
          href = html_options['href']
          tag_options = tag_options(html_options)
          
          href_attr = "href=\"#{html_escape(url)}\"" unless href
          "<a #{href_attr}#{tag_options}>#{html_escape(name || url)}</a>".html_safe
        end
      end
      
      # button_to for the OpenSocial WAP Extension.
      #
      # イニシャライザ、コントローラでの設定に基づいて、OpenSocial WAP用URLをセットする.
      # html_options引数に、:url_settings というキーで値を指定して、URL書き換え定を上書きすることができる.
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

        url_settings = extract_url_settings(html_options)

        url = url_for(options, url_settings)
        name ||= url
        
        html_options = convert_options_to_data_attributes(options, html_options)
        
        html_options.merge!("type" => "submit", "value" => name)
        
        ("<form method=\"#{form_method}\" action=\"#{html_escape(url)}\" #{"data-remote=\"true\"" if remote} class=\"button_to\"><div>" +
         method_tag + tag("input", html_options) + request_token_tag + "</div></form>").html_safe
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
          # link_to, button_to 系では、:default の設定を使用する.
          url_settings = default_url_settings.default
        end
        url_settings
      end
    end
  end
end

