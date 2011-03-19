# -*- coding: utf-8 -*-

module OpensocialWap
  module Rack
    module RequestWithOpensocialOauth
      def opensocial_oauth_verified?
        env['opensocial-wap.oauth-verified']
      end

      def access_token
        env['opensocial-wap.access_token']
      end
    end
  end
end

class Rack::Request
  include OpensocialWap::Rack::RequestWithOpensocialOauth
end

