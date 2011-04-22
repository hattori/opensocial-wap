# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Platform do
  describe "gree" do
    it "sandbox用に、GREE用の初期化が正しく行えること(セッションOFF)" do
      c = Rails::Application::Configuration.new
      OpensocialWap::Platform.new(c).gree do
        consumer_key '1234'
        consumer_secret 'abcd'
        sandbox true
        session false
      end

debugger
      c.opensocial_wap.oauth.helper_class.should == OpensocialWap::OAuth::Helpers::BasicHelper
      c.opensocial_wap.oauth.helper_class.proxy_class.should == OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxy
      c.opensocial_wap.oauth.helper_class.consumer_key.should == '1234'
      c.opensocial_wap.oauth.helper_class.consumer_secret.should == 'abcd'
      c.opensocial_wap.oauth.helper_class.api_endpoint.should == 'http://os-sb.gree.jp/api/rest/'
      c.opensocial_wap.url.default.should == {:format => :query, :params => { :guid => 'ON' }}
      c.opensocial_wap.url.redirect.should == {:format => :local}
      c.opensocial_wap.url.public_path.should == {:format => :local}
      c.opensocial_wap.session_id.should_not == :parameter
    end

    it "本番用に、GREE用の初期化が正しく行えること(セッションON)" do
      c = Rails::Application::Configuration.new
      OpensocialWap::Platform.new(c).gree do
        consumer_key '1234'
        consumer_secret 'abcd'
        sandbox false
        session true
      end

debugger
      c.opensocial_wap.oauth.helper_class.should == OpensocialWap::OAuth::Helpers::BasicHelper
      c.opensocial_wap.oauth.helper_class.proxy_class.should == OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxy
      c.opensocial_wap.oauth.helper_class.consumer_key.should == '1234'
      c.opensocial_wap.oauth.helper_class.consumer_secret.should == 'abcd'
      c.opensocial_wap.oauth.helper_class.api_endpoint.should == 'http://os.gree.jp/api/rest/'
      c.opensocial_wap.url.default.should == {:format => :query, :params => { :guid => 'ON' }}
      c.opensocial_wap.url.redirect.should == {:format => :local}
      c.opensocial_wap.url.public_path.should == {:format => :local}
      c.opensocial_wap.session_id.should == :parameter
    end
  end
end
