# -*- coding: utf-8 -*-

module OpensocialWap
  module Config

    # OAuth 関係設定.
    class OAuth
      def initialize
        yield self
        self.freeze
      end

      def oauth_helper(helper = nil)
        if helper
          @oauth_helper = helper
        end
        @oauth_helper
      end

      def api_endpoint(endpoint = nil)
        if endpoint
          @api_endpoint = endpoint
        end
        @api_endpoint
      end
    end
  end
end
