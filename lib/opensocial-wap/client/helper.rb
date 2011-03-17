# -*- coding: utf-8 -*-
require 'uri'
require 'net/http'

module OpensocialWap
  module Client
    class Helper < ::OAuth::Client::Helper
      # ベースクラスでの実装に、xoauth_requestor_id を追加.
      def oauth_parameters
        params = super
        if options[:xoauth_requestor_id] && options[:xoauth_requestor_id] != ""
          params["xoauth_requestor_id"] = options[:xoauth_requestor_id]
        end
        params
      end
    end
  end
end
      
