require 'spec_helper'

module OpensocialWap
  module Config
    describe OAuth do
      it do
        config = ::OpensocialWap::Config::OAuth.new do |config|
          config.helper_class "OAuth Helper Class"
          config.api_endpoint "http://api.example.com"
        end

        config.helper_class.should == "OAuth Helper Class"
        config.api_endpoint.should == "http://api.example.com"

        lambda{config.helper_class "Other Class"}.should raise_error(Exception)
        lambda{config.api_endpoint "http://other_api.example.com"}.should raise_error(Exception)
      end
    end
  end
end
