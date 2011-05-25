# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Platform do
  describe "mobage" do
    it "sandbox用に、mobage用の初期化が正しく行えること(セッションOFF)" do
      c = Rails::Application::Configuration.new
      OpensocialWap::Platform.mobage(c) do
        consumer_key '1234'
        consumer_secret 'abcd'
        app_id '9999'
        sandbox true
        session false
      end

      c.opensocial_wap.oauth.helper_class.should == OpensocialWap::OAuth::Helpers::MobageHelper
      c.opensocial_wap.oauth.helper_class.proxy_class.should == OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxy
      c.opensocial_wap.oauth.helper_class.consumer_key.should == '1234'
      c.opensocial_wap.oauth.helper_class.consumer_secret.should == 'abcd'
      c.opensocial_wap.oauth.helper_class.api_endpoint.should == 'http://sb.app.mbga.jp/api/restful/v1/'
      c.opensocial_wap.oauth.helper_class.app_id.should == '9999'
      c.opensocial_wap.url.container_host 'sb.pf.mbga.jp'
      c.opensocial_wap.url.default.should == {:format => :query, :params => { :guid => 'ON' }}
      c.opensocial_wap.url.redirect.should == {:format => :local}
      c.opensocial_wap.url.public_path.should == {:format => :local}
      c.opensocial_wap.session_id.should_not == :parameter
    end

    it "本番用に、mobage用の初期化が正しく行えること(セッションON)" do
      c = Rails::Application::Configuration.new
      OpensocialWap::Platform.mobage(c) do
        consumer_key '1234'
        consumer_secret 'abcd'
        app_id '9999'
        sandbox false
        session true
      end

      c.opensocial_wap.oauth.helper_class.should == OpensocialWap::OAuth::Helpers::MobageHelper
      c.opensocial_wap.oauth.helper_class.proxy_class.should == OpensocialWap::OAuth::RequestProxy::OAuthRackRequestProxy
      c.opensocial_wap.oauth.helper_class.consumer_key.should == '1234'
      c.opensocial_wap.oauth.helper_class.consumer_secret.should == 'abcd'
      c.opensocial_wap.oauth.helper_class.api_endpoint.should == 'http://app.mbga.jp/api/restful/v1/'
      c.opensocial_wap.oauth.helper_class.app_id.should == '9999'
      c.opensocial_wap.url.container_host 'pf.mbga.jp'
      c.opensocial_wap.url.default.should == {:format => :query, :params => { :guid => 'ON' }}
      c.opensocial_wap.url.redirect.should == {:format => :local}
      c.opensocial_wap.url.public_path.should == {:format => :local}
      c.opensocial_wap.session_id.should == :parameter
    end
  end
end
