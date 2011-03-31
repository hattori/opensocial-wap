require 'spec_helper'

module OpensocialWap
  module Config
    describe OAuth do
      it do
        config = ::OpensocialWap::Config::OAuth.new do |config|
          config.helper_class "OAuth Helper Class"
        end

        config.helper_class.should == "OAuth Helper Class"

        lambda{config.helper_class "Other Class"}.should raise_error(Exception)
      end
    end
  end
end
