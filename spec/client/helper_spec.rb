require 'spec_helper'
require 'net/http'
require 'uri'

describe "Mixi" do
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

  # it do
  #   req = Net::HTTP::Get.new('http://api-example.mixi.jp/people/@me/@self')
  #   oauth_helper = OAuth::Client::Helper.new(req, opts.merge(:request_uri=> req.path))
  #   #puts oauth_helper.signature_base_string
  # end

  it do
    uri = URI.parse("http://api.mixi-platform.com/os/0.8/people/@me/@self")
    http = Net::HTTP::start(uri.host, 80)
    req = Net::HTTP::Get.new(uri.request_uri)
    oauth_helper = OpensocialWap::Client::Helper.new(req, opts.merge(:request_uri=> uri.to_s))

    response = http.get(uri.request_uri, {"Authorization" => oauth_helper.header})
    #puts response.body
    response.code.should == '200'
  end

  it do
    uri = URI.parse("http://api.mixi-platform.com/os/0.8/people/@me/@self?format=atom&fields=birthday,gender")
    http = Net::HTTP::start(uri.host, 80)
    req = Net::HTTP::Get.new(uri.request_uri)
    oauth_helper = OpensocialWap::Client::Helper.new(req, opts.merge(:request_uri=> uri.to_s))

    response = http.get(uri.request_uri, {"Authorization" => oauth_helper.header})
    #puts response.body
    response.code.should == '200'
  end

  it do
    uri = URI.parse("http://api.mixi-platform.com/os/0.8/appdata/@me/@self/@app")
    postData = '{"class": "Dark Knight"}'

    http = Net::HTTP::start(uri.host, 80)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = postData
    oauth_helper = OpensocialWap::Client::Helper.new(req, opts.merge(:request_uri=> uri.to_s))

    response = http.post(uri.request_uri, postData, {"Authorization" => oauth_helper.header, 'Content-Type' => 'application/json'})
    response.code.should == '200'

    #puts response.body
    #p response['WWW-Authenticate']
  end

end


describe 'GREE' do
  def consumer
    consumer_key = "1a56166d58f0"
    consumer_secret = "cb405a1aa77faa493cbd3b06db5e7955"
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret)
  end
  
  def token
    token = '1b62f4f2084dd397969f94e0edb91c2c'
    token_secret = 'aeee56af6e00891d9ce412bc80458dfc'
    OAuth::RequestToken.new(consumer, token, token_secret)
  end

  def opts
    opts = {
      :consumer => consumer,
      :token => token,
      :xoauth_requestor_id => guid
    }
  end

  def guid
    '7339'
  end

  it do
    uri = URI.parse("http://os-sb.gree.jp/api/rest/people/@me/@self")
    http = Net::HTTP::start(uri.host, 80)
    req = Net::HTTP::Get.new(uri.request_uri)
    oauth_helper = OpensocialWap::Client::Helper.new(req, opts.merge(:request_uri=> uri.to_s))
    response = http.get(uri.request_uri, {"Authorization" => oauth_helper.header})
    #puts response.body
    response.code.should == '200'
  end

  it do
    uri = URI.parse("http://os-sb.gree.jp/api/rest/people/@me/@self?fields=birthday,gender")
    http = Net::HTTP::start(uri.host, 80)
    req = Net::HTTP::Get.new(uri.request_uri)
    oauth_helper = OpensocialWap::Client::Helper.new(req, opts.merge(:request_uri=> uri.to_s))
    response = http.get(uri.request_uri, {"Authorization" => oauth_helper.header})
    #puts response.body
    response.code.should == '200'
  end

  it do
    uri = URI.parse("http://os-sb.gree.jp/api/rest/appdata/@me/@self/@app")
    postData = '{"class": "Dark Knight"}'

    http = Net::HTTP::start(uri.host, 80)
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = postData
    oauth_helper = OpensocialWap::Client::Helper.new(req, opts.merge(:request_uri=> uri.to_s))

    response = http.post(uri.request_uri, postData, {"Authorization" => oauth_helper.header, 'Content-Type' => 'application/json'})
    response.code.should match /2\d\d/

    #puts response.body
    #p response['WWW-Authenticate']
  end
end
