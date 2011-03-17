# -*- coding: utf-8 -*-

module OpensocialWap
  module Config

    # Url 関係設定.
    class Url
      def initialize
        yield self
        self.freeze
      end

      def default(options = nil)
        if options
          @default = options
        end
        @default
      end

      def redirect(options = nil)
        if options
          @redirect = options
        end
        @redirect || @default
      end

      def public_path(options = nil)
        if options
          @public_path = options
        end
        @public_path || @default
      end
    end
  end
end
