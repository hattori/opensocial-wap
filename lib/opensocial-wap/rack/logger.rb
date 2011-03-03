# encoding: UTF-8

module OpensocialWap
  module Rack
    class LogLevel
      DEBUG   = 0
      INFO    = 1
      WARN    = 2
      ERROR   = 3
      FATAL   = 4
      UNKNOWN = 5
      LABELS=['DEBUG','INFO','WARN','ERROR','FATAL','UNKNOWN']
      def self.log_level_to_label log_level
        LABELS[log_level] 
      end
      def self.label_to_log_level log_level_label
        LABELS.index log_level_label.to_s.upcase
      end
    end
    class Logger
      LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S'
      def initialize logger, log_level
        @logger = logger
        @log_level = log_level
      end
      def isDebug
         isLogLevel LogLevel::DEBUG
      end
      def isInfo
         isLogLevel LogLevel::INFO
      end
      def isWarn
         isLogLevel LogLevel::WARN
      end
      def isError
         isLogLevel LogLevel::ERROR
      end
      def isFatal
         isLogLevel LogLevel::FATAL
      end
      def isLogLevel log_level
         log_level <= @log_level
      end
      def debug msg
        log LogLevel::DEBUG, msg
      end
      def info msg
        log LogLevel::INFO, msg
      end
      def warn msg
        log LogLevel::WARN, msg
      end
      def error msg
        log LogLevel::ERROR, msg
      end
      def fatal msg
        log LogLevel::FATAL, msg
      end
      def log(log_level, msg)
        if isLogLevel log_level
          @logger.write "\n[#{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] #{LogLevel::log_level_to_label(log_level)} #{msg}"
        end
      end
    end
  end
end
