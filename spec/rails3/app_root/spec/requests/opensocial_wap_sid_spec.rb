# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::Session::OpensocialWapSid do
  fixtures :users

  describe "GET users#edit" do
    before do
      page.reset!
    end

    it "OAuth検証にパスし、opensocial_viewer_idパラメータが存在すれば、セッションキーはopensocial_viewer_idの値になること." do

      # テストのために、強制的に OAuth 検証パス状態に設定し、opensocial_viewer_id をパラメターにセット.
      # OpensocialWapSidEnabler 内で env を操作する.
      opensocial_viewer_id = "xYke81b0aHLvbafdsa"
      app.config.enable_opensocial_wap_sid = true
      app.config.opensocial_wap_sid_with_parameter = {"opensocial_viewer_id" => opensocial_viewer_id}
      
      visit edit_user_path(users(:alice))

      page.should have_content opensocial_viewer_id

      fill_in "user_name", :with => "Alice"
      fill_in "user_age", :with => 14

      click_button "Update User"
      
      page.should have_content "User was successfully updated."
      page.should have_content "14"
    end

    it "OAuth検証に失敗したら、opensocial_viewer_idパラメータが存在しても、セッションキーはopensocial_viewer_idの値にならないこと." do
      # テストのために、強制的に OAuth検証失敗状態に設定.
      opensocial_viewer_id = "xYke81b0aHLvbafdsa"
      app.config.enable_opensocial_wap_sid = false
      app.config.opensocial_wap_sid_with_parameter = {"opensocial_viewer_id" => opensocial_viewer_id}

      visit edit_user_path(users(:alice))

      page.should_not have_content opensocial_viewer_id

      fill_in "user_name", :with => "Alice"
      fill_in "user_age", :with => 14

      click_button "Update User"
      
      # cookie にセッションキーを保存するので、それでもセッションは有効になる.
      page.should have_content "User was successfully updated."
      page.should have_content "14"
    end

    it "Rails.application.config.opensocial_wap.sidの値が:parameterでなければ、セッションキーはopensocial_viewer_idの値にならないこと." do

      app.config.opensocial_wap.sid = :session

      # テストのために、強制的に OAuth 検証パス状態に設定し、opensocial_viewer_id をパラメターにセット.
      # OpensocialWapSidEnabler 内で env を操作する.
      opensocial_viewer_id = "xYke81b0aHLvbafdsa"
      app.config.enable_opensocial_wap_sid = true
      app.config.opensocial_wap_sid_with_parameter = {"opensocial_viewer_id" => opensocial_viewer_id}
      
      visit edit_user_path(users(:alice))

      page.should_not have_content opensocial_viewer_id

      fill_in "user_name", :with => "Alice"
      fill_in "user_age", :with => 14

      click_button "Update User"
      
      page.should have_content "User was successfully updated."
      page.should have_content "14"
    end
  end
end
