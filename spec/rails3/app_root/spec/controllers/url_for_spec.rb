# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Routing::UrlFor do

  controller do
    opensocial_wap({ :url_format => :query,
                     :params => { :guid => 'ON' }, 
                     :container_url => 'http://container.example.com/'})

    def index
      user = User.new
      
      case params[:url_format]
      when 'original'
        @u = url_for(user) 
      when 'default'
        @u = url_for(user, self.class.opensocial_wap_options)
      else
        @u = url_for(user, self.class.opensocial_wap_options.merge(:url_format => params[:url_format].to_sym))
      end
      render :text => "OK"
    end
  end

  describe 'url_forによるURLの構築.' do
    it "url_for を 2番目の引数(osw_options)を指定せずによびだすと、従来の形式の URL が返されること" do
      get :index, :url_format => 'original'
      assigns(:u).should == "http://test.host/users"
    end

    it "url_for の 2番目の引数(osw_optsions)にコントローラーに設定した値を指定すると、設定した :url_format に応じた URL が返されること" do
      get :index, :url_format => 'default'
      assigns(:u).should == "?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers"
    end

    it ":url_format を :plain にすると、アプリケーションサーバのURL(パスも含む)が返されること" do
      get :index, :url_format => :plain
      assigns(:u).should == "http://test.host/users"
    end

    it ":url_format を :query にすると、OpenSocial WAP :query 形式のURLが返されること" do
      get :index, :url_format => 'query'
      assigns(:u).should == "?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers"
    end

    it ":url_format を :full にすると、OpenSocial WAP :full 形式のURLが返されること" do
      get :index, :url_format => 'full', :opensocial_app_id => '12345'
      assigns(:u).should == "http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers"
    end
  end
end
