# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Helpers::UrlHelper do

  describe "#url_for" do
    context "osw_options を指定していない場合" do
      it "従来の形式の URL を返すこと" do
        controller = UsersController.new
        user = User.create(:name => 'Alice', :age => 15)
        helper.url_for(user).should == "/users/#{user.id}"
      end
    end
    
    context "osw_options を指定している場合" do
      it ":url_format が :plain であれば、指定した形式の URL を返すこと" do
        controller = UsersController.new
        osw_options = controller.class.opensocial_wap_options.merge(:url_format => :plain)
        helper.url_for(User.new, osw_options).should == "http://host.example.com/users"
      end

      it ":url_format が :query であれば、指定した形式の URL を返すこと" do
        controller = UsersController.new
        osw_options = controller.class.opensocial_wap_options.merge(:url_format => :query)
        helper.url_for(User.new, osw_options).should == "?guid=ON&url=http%3A%2F%2Fhost.example.com%2Fusers"
      end

      it ":url_format が :full であれば、指定した形式の URL を返すこと" do
        controller = UsersController.new
debugger
        controller.params = { :opensocial_app_id => '12345'}
        osw_options = controller.class.opensocial_wap_options.merge(:url_format => :full)
        helper.url_for(User.new, osw_options).should == "http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Fhost.example.com%2Fusers"
      end
    end
  end

  describe "#link_to" do
    it "リンク先URL が、controller の opensocial_wap での指定に従って、OpenSocial WAP Extension形式のURLになること" do
      controller = UsersController.new
      user = User.stub(:find).with("37") { mock_user }
      helper.link_to(user).should == "?guid=ON&url=http%3A%2F%2Fhost.example.com%2Fusers%2F37"
    end

  end

  describe "#button_to" do
    pending
  end
  describe "#link_to_unless_current" do
    pending
  end
  describe "#link_to_unless" do
    pending
  end
  describe "#link_to_if" do
    pending
  end

end
