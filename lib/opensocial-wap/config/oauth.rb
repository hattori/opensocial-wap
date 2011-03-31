# -*- coding: utf-8 -*-

module OpensocialWap
  module Config

    # OAuth 関係設定.
    class OAuth
      def initialize
        yield self
        self.freeze
      end

      def helper_class(klass = nil)
        if klass
          @helper_class = klass
        end
        @helper_class
      end
    end
  end
end
