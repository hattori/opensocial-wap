# -*- coding: utf-8 -*-

module OpensocialWap
  module Helpers
    module FormTagHelper
      include Base

      # ただし、parameters_for_url の部分に、:osw_options ハッシュを渡すことができる
      def form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
        super
      end

      private
      
      def html_options_for_form(url_for_options, options, *parameters_for_url)
        # call super unless opensocial_wap is not called in the controller.
        super unless default_osw_options

        options.stringify_keys.tap do |html_options|
          html_options["enctype"] = "multipart/form-data" if html_options.delete("multipart")
          # ows_options を、options から取り出す.
          osw_options = default_osw_options.merge(options[:osw_options] || {})
          # The following URL is unescaped, this is just a hash of options, and it is the
          # responsability of the caller to escape all the values.
          html_options["action"]  = url_for(url_for_options, osw_options, *parameters_for_url)
          html_options["accept-charset"] = "UTF-8"
          html_options["data-remote"] = true if html_options.delete("remote")
        end
      end
    end
  end
end
