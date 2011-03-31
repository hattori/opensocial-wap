# -*- coding: utf-8 -*-

module OpensocialWap
  module Rack
    module RequestWithOpensocialOauth
      def opensocial_oauth_verified?
        env['opensocial-wap.oauth-verified']
      end

      def oauth_helper
        env['opensocial-wap.helper']
      end
    end
  end
end

class Rack::Request
  include OpensocialWap::Rack::RequestWithOpensocialOauth
end
