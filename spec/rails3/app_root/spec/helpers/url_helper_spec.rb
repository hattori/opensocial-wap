# -*- coding: utf-8 -*-
require 'spec_helper'

# コントローラをセット.
def set_controller(c)
  controller = c
  helper.controller = c
  c.request = helper.request
  helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
end

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
        helper.stub!(:params).and_return({ :opensocial_app_id => '12345' })
        osw_options = controller.class.opensocial_wap_options.merge(:url_format => :full)
        helper.url_for(User.new, osw_options).should == "http://container.example.com/12345/?guid=ON&url=http%3A%2F%2Fhost.example.com%2Fusers"
      end
    end
  end

  describe "#link_to" do

    context NonOpensocialWapController do

      it "リンクのURLが、通常の形式になること(パスを引数にした場合)" do
        set_controller(NonOpensocialWapController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user_path(user)).should == link
      end
    
      it "リンクのURLが、通常の形式になること(モデルを引数にした場合)" do
        set_controller(NonOpensocialWapController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user).should == link
      end

      it "リンクのURLが、通常の形式になること(Hashを引数にした場合)" do
        set_controller(NonOpensocialWapController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", :controller=>"users", :action=>"show", :id=>user).should == link
      end

      it "外部URLの場合、そのままのURLが出力されること" do
        set_controller(NonOpensocialWapController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://alice.example.com">Alice</a>|
        helper.link_to("Alice", "http://alice.example.com").should == link
      end

      it "HTMLオプションが正しく追加されること" do
        set_controller(NonOpensocialWapController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="/users/#{user.id}" id="user">Alice</a>|
        helper.link_to("Alice", user, :id=>"user").should == link
      end

      it "link_to メソッドのオプションで、URL形式を変更できること" do
        set_controller(NonOpensocialWapController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link_plain = %Q|<a href="http://host.example.com/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :plain}).should == link_plain

        link_query = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :query}).should == link_query

        link_full = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :full}).should == link_full
      end
    end

    context OpensocialWapPlainController do

      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(パスを引数にした場合)" do
        set_controller(OpensocialWapPlainController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://host.example.com/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user_path(user)).should == link
      end
    
      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(モデルを引数にした場合)" do
        set_controller(OpensocialWapPlainController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://host.example.com/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user).should == link
      end

      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(Hashを引数にした場合)" do
        set_controller(OpensocialWapPlainController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://host.example.com/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", :controller=>"users", :action=>"show", :id=>user).should == link
      end

      it "外部URLの場合、リンクのURLが、Opensocial WAP の影響を受けないこと" do
        set_controller(OpensocialWapPlainController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://alice.example.com">Alice</a>|
        helper.link_to("Alice", "http://alice.example.com").should == link
      end

      it "HTMLオプションが正しく追加されること" do
        set_controller(OpensocialWapPlainController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://host.example.com/users/#{user.id}" id="user">Alice</a>|
        helper.link_to("Alice", user, :id=>"user").should == link
      end

      it "link_to メソッドのオプションで、URL形式を変更できること" do
        set_controller(OpensocialWapPlainController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link_query = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :query}).should == link_query

        link_full = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :full}).should == link_full
      end
    end
    
    context OpensocialWapQueryController do
      
      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(パスを引数にした場合)" do
        set_controller(OpensocialWapQueryController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user_path(user)).should == link
      end
    
      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(モデルを引数にした場合)" do
        set_controller(OpensocialWapQueryController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user).should == link
      end

      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(Hashを引数にした場合)" do
        set_controller(OpensocialWapQueryController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", :controller=>"users", :action=>"show", :id=>user).should == link
      end

      it "外部URLの場合、リンクのURLが、Opensocial WAP の影響を受けないこと" do
        set_controller(OpensocialWapQueryController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://alice.example.com">Alice</a>|
        helper.link_to("Alice", "http://alice.example.com").should == link
      end

      it "HTMLオプションが正しく追加されること" do
        set_controller(OpensocialWapQueryController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}" id="user">Alice</a>|
        helper.link_to("Alice", user, :id=>"user").should == link
      end

      it "link_to メソッドのオプションで、URL形式を変更できること" do
        set_controller(OpensocialWapQueryController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link_plain = %Q|<a href="http://host.example.com/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :plain}).should == link_plain

        link_full = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :full}).should == link_full
      end
    end
    
    describe OpensocialWapFullController do
      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(パスを引数にした場合)" do
        set_controller(OpensocialWapFullController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user_path(user)).should == link
      end
    
      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(モデルを引数にした場合)" do
        set_controller(OpensocialWapFullController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user).should == link
      end

      it "リンクのURLが、Opensocial WAP :plain形式のURLになること(Hashを引数にした場合)" do
        set_controller(OpensocialWapFullController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", :controller=>"users", :action=>"show", :id=>user).should == link
      end

      it "外部URLの場合、リンクのURLが、Opensocial WAP の影響を受けないこと" do
        set_controller(OpensocialWapFullController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://alice.example.com">Alice</a>|
        helper.link_to("Alice", "http://alice.example.com").should == link
      end

      it "HTMLオプションが正しく追加されること" do
        set_controller(OpensocialWapFullController.new)
        user = User.create(:name => 'Alice', :age => 15)

        link = %Q|<a href="http://container.example.com/12345/?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}" id="user">Alice</a>|
        helper.link_to("Alice", user, :id=>"user").should == link
      end

      it "link_to メソッドのオプションで、URL形式を変更できること" do
        set_controller(OpensocialWapFullController.new)        
        user = User.create(:name => 'Alice', :age => 15)

        link_plain = %Q|<a href="http://host.example.com/users/#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :plain}).should == link_plain

        link_query = %Q|<a href="?guid=ON&amp;url=http%3A%2F%2Fhost.example.com%2Fusers%2F#{user.id}">Alice</a>|
        helper.link_to("Alice", user, {}, {:url_format => :query}).should == link_query
      end
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
