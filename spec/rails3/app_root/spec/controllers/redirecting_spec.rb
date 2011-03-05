# -*- coding: utf-8 -*-
require 'spec_helper'

module TestController
  def index
    format = params[:format] || "polymorphic"
    case format
    when "hash"
      redirect_to :controller => "users", :action => "new"
    else
      redirect_to User.new
    end
  end
end

describe OpensocialWap::ActionController::Redirecting do

  context "コントローラで opensocial_wap が宣言されていない場合" do
    controller do
      include TestController
    end

    it "アプリケーションサーバのホスト名を含めたURLにリダイレクトされること" do
      get :index, :opensocial_app_id => '12345'
      response.should redirect_to("http://test.host/users")
    end
    it "アプリケーションサーバのホスト名を含めたURLにリダイレクトされること" do
      get :index, :format => "hash", :opensocial_app_id => '12345'
      response.should redirect_to("http://test.host/users/new")
    end
  end

  context "コントローラで :redirect_url_format が指定されていない場合" do
    controller do
      opensocial_wap
      include TestController
    end

    it "初期化時に指定した :redirect_url_format に従ってリダイレクト先が決定すること" do
      get :index, :opensocial_app_id => '12345'
      response.should redirect_to("http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers")
    end
    it "初期化時に指定した :redirect_url_format に従ってリダイレクト先が決定すること" do
      get :index, :format => "hash", :opensocial_app_id => '12345'
      response.should redirect_to("http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers%2Fnew")
    end
  end

  context "コントローラで :redirect_url_format として :plain が指定されている場合" do
    controller do
      opensocial_wap :redirect_url_format => :plain
      include TestController
    end

    it do
      get :index, :opensocial_app_id => '12345'
      response.should redirect_to("http://test.host/users")
    end
    it do
      get :index, :format => "hash", :opensocial_app_id => '12345'
      response.should redirect_to("http://test.host/users/new")
    end
  end

  context "コントローラで :redirect_url_format として :query が指定されている場合" do
    controller do
      opensocial_wap :redirect_url_format => :query
      include TestController
    end
    it do
      get :index, :opensocial_app_id => '12345'
      response.should redirect_to("?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers")
    end
    it do
      get :index, :format => "hash", :opensocial_app_id => '12345'
      response.should redirect_to("?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers%2Fnew")
    end
  end

  context "コントローラで :redirect_url_format として :full が指定されている場合" do
    controller do
      opensocial_wap :redirect_url_format => :full
      include TestController
    end
    it do
      get :index, :opensocial_app_id => '12345'
      response.should redirect_to("http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers")
    end
    it do
      get :index, :format => "hash", :opensocial_app_id => '12345'
      response.should redirect_to("http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Ftest.host%2Fusers%2Fnew")
    end
  end
end
