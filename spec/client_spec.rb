require 'spec_helper'
require 'net/http'
require 'uri'

describe OpensocialWap::Client do
  
  context "Mixi" do
    def consumer
      consumer_key = "719c47bd50c0edae203b"
      consumer_secret = "cbba13bfbe00e606a0c4f66cab8de13591dcc379"
      OAuth::Consumer.new(consumer_key, consumer_secret)
    end
    
    def opts
      {
        :consumer => consumer,
        :token => nil,
        :xoauth_requestor_id => guid,
      }
    end
    
    def guid
      '21533604'
    end
    
    def rest_api
      OpensocialWap::RestApi.new(:options => opts,
                                 :endpoint => "http://api.mixi-platform.com/os/0.8/")
    end

    it do
      client = rest_api.get.people('@me', '@self', {:format => 'atom', :fields => 'gender,addresses'})
      response = client.run
    end

    it do
      client = OpensocialWap::Client::Get.new(:options => opts, 
                                              :endpoint => "http://api.mixi-platform.com/os/0.8/")
      client.people('@me', '@self', {:format => 'atom', :fields => 'gender,addresses'})
      request = client.request
#puts client.authorization_header
#p request
      client.run
      response = client.response
      response.code.should == '200'
#puts response.body
    end

    it do
      client = OpensocialWap::Client::Post.new(:options => opts, 
                                               :endpoint => "http://api.mixi-platform.com/os/0.8/")
      client.appdata('@me', '@self', '@app')
      client.post_data = '{"class": "Dark Knight"}'
      client.headers = {'Content-Type' => 'application/json' }
      
      client.run
      response = client.response
      response.code.should == '200'
#p response
    end
  end


end
