module OpensocialWap
  class Platform
    def initialize(config)
      @config = config
      @session = true
    end

    def consumer_key(key)
      @consumer_key = key
    end
    
    def consumer_secret(secret)
      @consumer_secret = secret
    end

    def session(enabled = true)
      @session = enabled
    end
  end
end
