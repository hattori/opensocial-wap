# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Platform do
  describe "mixi" do
    it "mixi用の初期化が正しく行えること" do
      c = Rails::Application::Configuration.new
      OpensocialWap::Platform.new(c).mixi do
        consumer_key '1234'
        consumer_secret 'abcd'
        session true
      end

      c.opensocial_wap.oauth.helper_class.should == OpensocialWap::OAuth::Helpers::BasicHelper
      c.opensocial_wap.oauth.helper_class.proxy_class.should == OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxyForMixi
      c.opensocial_wap.oauth.helper_class.consumer_key.should == '1234'
      c.opensocial_wap.oauth.helper_class.consumer_secret.should == 'abcd'
      c.opensocial_wap.oauth.helper_class.api_endpoint.should == 'http://api.mixi-platform.com/os/0.8/'
      c.opensocial_wap.url.default.should == {:format => :query, :params => { :guid => 'ON' }}
      c.opensocial_wap.url.redirect.should == {:format => :full, :container_host => 'ma.test.mixi.net', :params => { :guid => 'ON' } }
      c.opensocial_wap.url.public_path.should == {:format => :local}
      c.opensocial_wap.session_id.should_not == :parameter
    end
  end
end
