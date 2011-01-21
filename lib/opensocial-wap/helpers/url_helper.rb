# -*- coding: utf-8 -*-

module OpensocialWap
  module Helpers
    module UrlHelper
      include Base
      include ::OpensocialWap::Routing::UrlFor

      # url_for for the OpenSocial WAP Extension.
      # ows_options が nil か、osw_options に :url_formatが指定されていない(もしくは偽)の
      # 場合、従来通りの url_for を実行する.
      # そうでない場合、osw_options の値で、コントローラーの opensocial_wap クラスメソッドの
      # 呼び出しで指定した値を上書きし、拡張url_forを呼び出す.
      def url_for(options = {}, osw_options = nil)
        url_format = osw_options && osw_options[:url_format]
        return super(options) unless url_format

        options ||= {}
        osw_options = default_osw_options.merge(osw_options || {})

        case options
        when :back
          controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
        else
          super(options, osw_options)
        end        
      end

      # link_to for the OpenSocial WAP Extension.
      # 4番目(ブロックが与えられている場合は3番目)の引数を osw_options と見なす.
      def link_to(*args, &block)
        if block_given?
          options      = args.first || {}
          html_options = args.second
          osw_options = args.third
          link_to(capture(&block), options, html_options, osw_options)
        else
          name         = args[0]
          options      = args[1] || {}
          html_options = args[2]
          osw_options = args[3]
          
          html_options = convert_options_to_data_attributes(options, html_options)
          # controller で指定したオプションを引数で上書き.
          url = url_for(options, default_osw_options.merge(osw_options || {}))
          href = html_options['href']
          tag_options = tag_options(html_options)
          
          href_attr = "href=\"#{html_escape(url)}\"" unless href
          "<a #{href_attr}#{tag_options}>#{html_escape(name || url)}</a>".html_safe
        end
      end
      
      # button_to for the OpenSocial WAP Extension.
      # 4番目の引数を ows_options とみなす.
      def button_to(name, options = {}, html_options = {}, osw_options = {})
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
        
        # controller で指定したオプションを引数で上書き.
        osw_options = default_osw_options.merge(osw_options)
        url = url_for(options, osw_options)
        name ||= url
        
        html_options = convert_options_to_data_attributes(options, html_options)
        
        html_options.merge!("type" => "submit", "value" => name)
        
        ("<form method=\"#{form_method}\" action=\"#{html_escape(url)}\" #{"data-remote=\"true\"" if remote} class=\"button_to\"><div>" +
         method_tag + tag("input", html_options) + request_token_tag + "</div></form>").html_safe
      end
      
      # link_to_unless_current for the OpenSocial WAP Extension.
      def link_to_unless_current(name, options = {}, html_options = {}, osw_options = {}, &block)
        link_to_unless current_page?(options), name, options, html_options, osw_options, &block
      end

      # link_to_unless for the OpenSocial WAP Extension.
      def link_to_unless(condition, name, options = {}, html_options = {}, osw_options = {}, &block)
        if condition
          if block_given?
            block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
          else
            name
          end
        else
          link_to(name, options, html_options, osw_options)
        end
      end

      # link_to_id for the OpenSocial WAP Extension.
      def link_to_if(condition, name, options = {}, html_options = {}, osw_options, &block)
        link_to_unless !condition, name, options, html_options, osw_options, &block
      end
    end
  end
end

