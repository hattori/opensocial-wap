# -*- coding: utf-8 -*-

module OpensocialWap
  module Rack
    module RequestWithOpensocialOauth
      def opensocial_oauth_verified?
        env['opensocial-wap.rack'] && env['opensocial-wap.rack']['OPENSOCIAL_OAUTH_VERIFIED']
      end
    end
  end
end

class Rack::Request
  include OpensocialWap::Rack::RequestWithOpensocialOauth
end

