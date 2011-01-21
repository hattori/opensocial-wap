# -*- coding: utf-8 -*-
module OpensocialWap
  module Helpers
    module FormHelper
      include Base

      def form_for(record_or_name_or_array, *args, &proc)                                                                                         
        super
      end
      
      #
      def apply_form_for_options!(object_or_array, options) #:nodoc:  
        # call super unless opensocial_wap is not called in the controller.
        super unless default_osw_options

        object = object_or_array.is_a?(Array) ? object_or_array.last : object_or_array
        object = convert_to_model(object)
        
        html_options =
          if object.respond_to?(:persisted?) && object.persisted?
            { :class  => options[:as] ? "#{options[:as]}_edit" : dom_class(object, :edit),
            :id => options[:as] ? "#{options[:as]}_edit" : dom_id(object, :edit),
            :method => :put }
          else
            { :class  => options[:as] ? "#{options[:as]}_new" : dom_class(object, :new),
            :id => options[:as] ? "#{options[:as]}_new" : dom_id(object),
            :method => :post }
          end
        
        options[:html] ||= {}
        options[:html].reverse_merge!(html_options)

        # osw_options 自体を options から取得
        osw_options = default_osw_options.merge(options[:osw_options] || {})
        url_for(object_or_array, osw_options)
      end
    end
  end
end
