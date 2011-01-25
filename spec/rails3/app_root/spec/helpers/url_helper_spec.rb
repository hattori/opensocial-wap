# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Helpers::UrlHelper do

  class ActionView::TestCase::TestController
    opensocial_wap :url_format => :query, :params => { :guid => 'ON' }, :container_url => 'http://container.example.com/'
  end

  describe "#url_for" do
    it "osw_options を指定しなければ、従来の形式でURLを構築すること" do
      helper.url_for(User.new).should == '/users'
    end
    
    it ":url_format で指定した形式で URL を構築できること" do
      #controller_class = helper.controller.class
      helper.url_for(User.new, {:url_format => :full, :params => {:p1 => 'xyz'}}).should == "http://container.example.com//?p1=xyz&url=http%253A%252F%252Ftest.host%252Fusers"
    end
  end

  describe "#link_to" do
    it "リンク先URL が、OpenSocial WAP Extension形式のURLになること" do
      user = User.stub(:find).with("37") { mock_user }
      p helper.link_to(user)
    end

  end

  describe "#button_to" do

  end

  describe "#link_to_unless_current" do

  end

  describe "#link_to_unless" do


  end

  describe "#link_to_if" do

  end

end
