# -*- coding: utf-8 -*-
require 'spec_helper'

# コントローラをセットする.
def set_controller(c)
  controller = c
  helper.controller = c
  c.request = helper.request
  helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
end

describe OpensocialWap::Helpers::FormTagHelper do

  describe "#form_tag" do

    context NonOpensocialWapController do

      before do
        set_controller(NonOpensocialWapController.new)
      end

      it "actionのURLが、通常の形式になること" do
        html = %Q|action="/users"|
        helper.form_tag('/users').should include html
      end

      it "URLが外部URLの場合、そのままの形で出力されること" do
        html = %Q|action="http://alice.example.com"|
          helper.form_tag('http://alice.example.com').should include html
      end

      it "options引数で指定した値で、URL形式を変更できること" do
        html_plain = %Q|action="http://host.example.com/users"|
          helper.form_tag('/users', :opensocial_wap => {:url_format => :plain}).should include html_plain

        html_query = %Q|action="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers"|
          helper.form_tag('/users', :opensocial_wap => {:url_format => :query}).should include html_query

        html_full = %Q|action="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers"|
          helper.form_tag('/users', :opensocial_wap => {:url_format => :full}).should include html_full
      end
    end

    context OpensocialWapPlainController do

      before do
        set_controller(OpensocialWapPlainController.new)
      end

      pending
    end

    context OpensocialWapQueryController do

      before do
        set_controller(OpensocialWapQueryController.new)
      end

      pending
    end

    context OpensocialWapFullController do

      before do
        set_controller(OpensocialWapFullController.new)
      end

      pending
    end

  end

  describe "#form_for" do

    context NonOpensocialWapController do
      pending
    end

    context OpensocialWapPlainController do
      pending
    end

    context OpensocialWapQueryController do
      pending
    end

    context OpensocialWapFullController do
      pending
    end

  end
end
