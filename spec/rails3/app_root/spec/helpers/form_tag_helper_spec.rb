# -*- coding: utf-8 -*-
require 'spec_helper'
require File.expand_path("helper_spec_helper", File.dirname(__FILE__))

describe OpensocialWap::Helpers::FormTagHelper do
  fixtures :users

  describe "#form_tag" do

    context NonOpensocialWapController do

      before do
        set_controller(NonOpensocialWapController.new)
      end

      it "actionのURLが、通常の形式になること" do
        html = helper.form_tag('/users')
        html.should include %Q|action="/users"|
      end

      it "URLが外部URLの場合、そのままの形で出力されること" do
        html = helper.form_tag('http://alice.example.com')
        html.should include %Q|action="http://alice.example.com"|
      end

      it "options引数で指定した値で、URL形式を変更できること" do
        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :plain})
        html.should include %Q|action="http://test.host/users"|

        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :query})
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|

        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :full})
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|
      end
    end

    context OpensocialWapPlainController do

      before do
        set_controller(OpensocialWapPlainController.new)
      end

      it "actionのURLが、Opensocial WAP :plain形式になること" do
        html = helper.form_tag('/users')
        html.should include %Q|action="http://test.host/users"|
      end

      it "URLが外部URLの場合、そのままの形で出力されること" do
        html = helper.form_tag('http://alice.example.com')
        html.should include %Q|action="http://alice.example.com"|
      end

      it "options引数で指定した値で、URL形式を変更できること" do
        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :query})
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|

        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :full})
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|
      end
    end

    context OpensocialWapQueryController do

      before do
        set_controller(OpensocialWapQueryController.new)
      end

      it "actionのURLが、Opensocial WAP :query形式になること" do
        html = helper.form_tag('/users')
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|
      end

      it "URLが外部URLの場合、そのままの形で出力されること" do
        html = helper.form_tag('http://alice.example.com')
        html.should include %Q|action="http://alice.example.com"|
      end

      it "options引数で指定した値で、URL形式を変更できること" do
        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :plain})
        html.should include %Q|action="http://test.host/users"|

        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :full})
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|
      end
    end

    context OpensocialWapFullController do

      before do
        set_controller(OpensocialWapFullController.new)
      end

      it "actionのURLが、Opensocial WAP :full形式になること" do
        html = helper.form_tag('/users')
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|
      end

      it "URLが外部URLの場合、そのままの形で出力されること" do
        html = helper.form_tag('http://alice.example.com')
        html.should include %Q|action="http://alice.example.com"|
      end

      it "options引数で指定した値で、URL形式を変更できること" do
        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :plain})
        html.should include %Q|action="http://test.host/users"|

        html = helper.form_tag('/users', :opensocial_wap => {:url_format => :query})
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers"|
      end
    end
  end

  describe "#form_for" do

    context NonOpensocialWapController do
      
      before do
        set_controller(NonOpensocialWapController.new)
      end

      it "actionのURLが通常の形式になること" do
        html = helper.form_for(users(:alice)){}
        html.should include %Q|action="/users/1"|
      end

      it "オプションが正しく反映されること" do
        html = helper.form_for(users(:alice), :format => :json, :html => { :method => :get } ){}
        html.should include %Q|action="/users/1.json"|
        html.should include %Q|method="get"|
      end

      it ":htmlオプションを使って、URL形式を変更できること" do
        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :plain}}){}
        html.should include %Q|action="http://test.host/users/1"|

        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :query}}){}
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|

        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :full}}){}
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|
      end
    end

    context OpensocialWapPlainController do

      before do
        set_controller(OpensocialWapPlainController.new)
      end

      it "actionのURLがOpensocial WAP :plain形式になること" do
        html = helper.form_for(users(:alice)){}
        html.should include %Q|action="http://test.host/users/1"|
      end

      it "オプションが正しく反映されること" do
        html = helper.form_for(users(:alice), :format => :json, :html => { :method => :get } ){}
        html.should include %Q|action="http://test.host/users/1.json"|
        html.should include %Q|method="get"|
      end

      it ":htmlオプションを使って、URL形式を変更できること" do
        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :query}}){}
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|

        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :full}}){}
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|
      end
    end

    context OpensocialWapQueryController do

      before do
        set_controller(OpensocialWapQueryController.new)
      end

      it "actionのURLがOpensocial WAP :query形式になること" do
        html = helper.form_for(users(:alice)){}
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|
      end

      it "オプションが正しく反映されること" do
        html = helper.form_for(users(:alice), :format => :json, :html => { :method => :get } ){}
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1.json"|
        html.should include %Q|method="get"|
      end

      it ":htmlオプションを使って、URL形式を変更できること" do
        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :plain}}){}
        html.should include %Q|action="http://test.host/users/1"|

        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :full}}){}
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|
      end
    end

    context OpensocialWapFullController do
      
      before do
        set_controller(OpensocialWapFullController.new)
      end

      it "actionのURLがOpensocial WAP :full形式になること" do
        html = helper.form_for(users(:alice)){}
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|
      end

      it "オプションが正しく反映されること" do
        html = helper.form_for(users(:alice), :format => :json, :html => { :method => :get } ){}
        html.should include %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1.json"|
        html.should include %Q|method="get"|
      end

      it ":htmlオプションを使って、URL形式を変更できること" do
        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :plain}}){}
        html.should include %Q|action="http://test.host/users/1"|

        html = helper.form_for(users(:alice), :html => {:opensocial_wap => {:url_format => :query}}){}
        html.should include %Q|action="?guid=ON&amp;url=http%3A%2F%2Ftest.host%2Fusers%2F1"|
      end
    end

  end
end
