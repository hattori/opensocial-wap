# -*- coding: utf-8 -*-

module OpensocialWap
  module Config

    # セッション関係設定.
    class Session
      def initialize
        yield self
        self.freeze
      end

      def session_id(option = nil)
        if option
          @session_id = option
        end
        @session_id
      end
    end
  end
end
