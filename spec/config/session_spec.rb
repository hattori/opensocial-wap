require 'spec_helper'

module OpensocialWap
  module Config
    describe Session do
      it do
        config = ::OpensocialWap::Config::Session.new do |config|
          config.session_id :parameter
        end

        config.session_id.should == :parameter

        lambda{config.sesion_id :cookie }.should raise_error(Exception)
      end
    end
  end
end
