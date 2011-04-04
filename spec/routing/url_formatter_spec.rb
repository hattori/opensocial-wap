# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Routing::UrlFormatter do

  describe "#plain_url_for" do
    it "plain形式のURLが正しく計算できること" do
      url = "/foo?bar=buz"
      host = "app.example.com"
      plain_url = OpensocialWap::Routing::UrlFormatter.plain_url_for(url, host)
      plain_url.should == 'http://app.example.com/foo?bar=buz'
    end

    it "プロトコル・ポートを指定した場合に、plain形式のURLが正しく計算できること" do 
      url = "/foo?bar=buz"
      host = "app.example.com"
      protocol = "https"
      port = 10443
      plain_url = OpensocialWap::Routing::UrlFormatter.plain_url_for(url, host, protocol, port)
      plain_url.should == 'https://app.example.com:10443/foo?bar=buz'
    end
  end

  describe "#query_url_for" do
    it "query形式のURLが正しく計算できること" do
      url = "http://app.example.com/foo?bar=buz"
      query_url = OpensocialWap::Routing::UrlFormatter.query_url_for(url)
      query_url.should == "?url=http%3A%2F%2Fapp.example.com%2Ffoo%3Fbar%3Dbuz"
    end

    it "パラメータを指定した場合に、query形式のURLが正しく計算できること" do
      url = "http://app.example.com/foo?bar=buz"
      params = {:guid => "ON"}
      query_url = OpensocialWap::Routing::UrlFormatter.query_url_for(url, params)
      query_url.should == "?guid=ON&url=http%3A%2F%2Fapp.example.com%2Ffoo%3Fbar%3Dbuz"
    end
  end

  describe "#full_url_for" do
    it "full形式のURLが正しく計算できること" do
      container_url = "http://container.example.com/"
      app_id = 123456
      url = "http://app.example.com/foo?bar=buz"
      full_url = OpensocialWap::Routing::UrlFormatter.full_url_for(container_url, app_id, url)
      full_url.should == "http://container.example.com/123456/?url=http%3A%2F%2Fapp.example.com%2Ffoo%3Fbar%3Dbuz"
    end

    it "パラメータを指定した場合に、full形式のURLが正しく計算できること" do
      container_url = "http://container.example.com/"
      app_id = 123456
      url = "http://app.example.com/foo?bar=buz"
      params = {:guid => "ON"}
      full_url = OpensocialWap::Routing::UrlFormatter.full_url_for(container_url, app_id, url, params)
      full_url.should == "http://container.example.com/123456/?guid=ON&url=http%3A%2F%2Fapp.example.com%2Ffoo%3Fbar%3Dbuz"
    end
  end


  describe "#base_url" do
    it "base_urlが正しく計算できること" do
      host = "app.example.com"
      url = OpensocialWap::Routing::UrlFormatter.base_url(host)
      url.should == "http://app.example.com"
    end

    it "プロトコル・ポートを指定した場合に、base_urlが正しく計算できること" do
      host = "app.example.com"
      protocol = "https"
      port = 10443
      url = OpensocialWap::Routing::UrlFormatter.base_url(host, protocol, port)
      url.should == "https://app.example.com:10443"
    end
  end
end
