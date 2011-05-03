require 'spec_helper'

module OpensocialWap
  module Config
    describe OAuth do
      it do
        config = OpensocialWap::Config::OAuth.configure do
          OpensocialWap::OAuth::Helpers::BasicHelper.configure do
            consumer_key    '1234'
            consumer_secret 'abcd'
            api_endpoint    'http://api.example.com/'
          end
          helper_class OpensocialWap::OAuth::Helpers::BasicHelper
        end

        config.helper_class.should == OpensocialWap::OAuth::Helpers::BasicHelper
        config.helper_class.consumer_key.should == '1234'
        config.helper_class.consumer_secret.should == 'abcd'
        config.helper_class.api_endpoint.should == 'http://api.example.com/'
      end
    end
  end
end
