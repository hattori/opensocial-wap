require 'spec_helper'

module OpensocialWap
  module Config
    describe Url do
      it do
        config = ::OpensocialWap::Config::Url.new do |config|
          config.default  :format => :full, :container_host => 'c.example.com', :params => { :guid => 'ON' }
          config.redirect :format => :query, :params => { :guid => 'ON' }
          config.public_path :format => :plain
        end

        config.default.should == {:format => :full, :container_host => 'c.example.com', :params => { :guid => 'ON' }}
        config.redirect.should == { :format => :query, :params => { :guid => 'ON' }}
        config.public_path.should == { :format => :plain }

        lambda{config.default :format => :plain }.should raise_error(Exception)
        lambda{config.redirect :format => :plain }.should raise_error(Exception)
        lambda{config.public_path :format => :plain }.should raise_error(Exception)
      end
    end
  end
end
