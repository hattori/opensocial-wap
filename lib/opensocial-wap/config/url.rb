# -*- coding: utf-8 -*-

# Url 関係設定.
module OpensocialWap
  module Config
    module Url
      # Singleton Pattern
      extend self

      def configure(&blk)
        instance_eval(&blk)
        self
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
