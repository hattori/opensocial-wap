# -*- coding: utf-8 -*-

require 'spec_helper'
require File.expand_path("helper_spec_helper", File.dirname(__FILE__))

describe OpensocialWap::Helpers::AssetTagHelper do

  before do
    reset_opensocial_wap_config(Rails.application.config)
  end

  describe "#image_path" do
    context "コントローラで opensocial_wap を指定していない場合" do
      it "初期化時に指定した形式の URL を返すこと" do
        set_controller(NonOpensocialWapController.new)
        helper.image_path("edit.png").should == "/images/edit.png"
      end
    end
    
    context "コントローラで opensocial_wap を指定している場合" do

      it "初期化時に指定した形式の URL を返すこと" do
        set_controller(OpensocialWapController.new)
        helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
        helper.image_path("edit.png").should == "http://test.host/images/edit.png"
      end
    end
  end
end
