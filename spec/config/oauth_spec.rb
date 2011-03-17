require 'spec_helper'

module OpensocialWap
  module Config
    describe OAuth do
      it do
        config = ::OpensocialWap::Config::OAuth.new do |config|
          config.oauth_helper "Test Helper"
          config.api_endpoint "http://api.example.com"
        end

        config.oauth_helper.should == "Test Helper"
        config.api_endpoint.should == "http://api.example.com"

        lambda{config.oauth_helper "Other Helper"}.should raise_error(Exception)
        lambda{config.api_endpoint "http://other_api.example.com"}.should raise_error(Exception)
      end
    end
  end
end
