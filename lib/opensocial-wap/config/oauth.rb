# -*- coding: utf-8 -*-

# OAuth 関係設定.
module OpensocialWap
  module Config
    module OAuth
      extend self
      
      def configure(&blk)
        instance_eval(&blk)
        self
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
