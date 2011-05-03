# -*- coding: utf-8 -*-
require 'spec_helper'

describe OpensocialWap::OAuth::ClientHelper do

  describe "#uri" do

    it "構築したAPIエンドポイントが正しいこと" do
      OpensocialWap::OAuth::Helpers::BasicHelper.configure do
        consumer_key    'abcde'
        consumer_secret 'fghijk'
        api_endpoint    'http://api.example.com/rest/'
      end
      oauth_helper = OpensocialWap::OAuth::Helpers::BasicHelper.new
      client_helper = OpensocialWap::OAuth::ClientHelper.new(oauth_helper, 
                                                             'people', 
                                                             '@me', 
                                                             '@self', 
                                                             :format => 'atom', :fields => 'gender,address')
      client_helper.uri.to_s.should == "http://api.example.com/rest/people/@me/@self?fields=gender%2Caddress&format=atom"
    end
  end

  describe "#authorization_header" do
    pending
  end
end
