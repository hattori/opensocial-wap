# -*- coding: utf-8 -*-
require 'spec_helper'

# コントローラをセットする.
def set_controller(c)
  controller = c
  helper.controller = c
  c.request = helper.request
  helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
end

describe OpensocialWap::Helpers::Base do
  fixtures :users

  describe "#url_for" do
    context "osw_options を指定していない場合" do
      it "従来の形式の URL を返すこと" do
        controller = NonOpensocialWapController.new
        helper.url_for(users(:alice)).should == "/users/1"
      end
    end
    
    context "osw_options を指定している場合" do
      it ":url_format が :plain であれば、指定した形式の URL を返すこと" do
        controller = OpensocialWapPlainController.new
        osw_options = controller.class.opensocial_wap_options
        helper.url_for(User.new, osw_options).should == "http://host.example.com/users"
      end

      it ":url_format が :query であれば、指定した形式の URL を返すこと" do
        controller = OpensocialWapQueryController.new
        osw_options = controller.class.opensocial_wap_options
        helper.url_for(User.new, osw_options).should == "?guid=ON&url=http%3A%2F%2Fhost.example.com%2Fusers"
      end

      it ":url_format が :full であれば、指定した形式の URL を返すこと" do
        controller = OpensocialWapFullController.new
        helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
        osw_options = controller.class.opensocial_wap_options
        helper.url_for(User.new, osw_options).should == "http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Fhost.example.com%2Fusers"
      end
    end
  end
end
