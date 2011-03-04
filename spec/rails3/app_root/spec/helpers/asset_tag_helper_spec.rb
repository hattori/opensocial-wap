# -*- coding: utf-8 -*-

require 'spec_helper'
require File.expand_path("helper_spec_helper", File.dirname(__FILE__))

describe OpensocialWap::Helpers::AssetTagHelper do

  describe "#image_path" do
    context "osw_options を指定していない場合" do
      it "初期化時に指定した形式の URL を返すこと" do
        set_controller(NonOpensocialWapController.new)
        helper.image_path("edit.png").should == "http://test.host/images/edit.png"
      end
    end
    
    context "osw_options を指定している場合" do
      it ":public_path_format が :plain であれば、指定した形式の URL を返すこと" do
        set_controller(OpensocialWapPlainController.new)
        helper.image_path("edit.png").should == "http://test.host/images/edit.png"
      end

      it ":public_path_format が :query であれば、指定した形式の URL を返すこと" do
        set_controller(OpensocialWapQueryController.new)
        helper.image_path("edit.png").should == "?guid=ON&url=http%3A%2F%2Ftest.host%2Fimages%2Fedit.png"
      end

      it ":public_path_format が :full であれば、指定した形式の URL を返すこと" do
        set_controller(OpensocialWapFullController.new)
        helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
        helper.image_path("edit.png").should == "http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Ftest.host%2Fimages%2Fedit.png"
      end
    end
  end
end
