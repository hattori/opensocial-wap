# -*- coding: utf-8 -*-
require 'spec_helper'

require 'opensocial-wap/oauth/request_proxy/rack_request_patch'

describe OpensocialWap::OAuth::RequestProxy::RackRequestPatch do
  
  it "POSTデータの解析結果が、パッチの内容を反映していること" do
    uri = 'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value'
    opts = {
      :method => "POST",
      :params => "a=b&c=d",
      :input => "_method=put&var%5Bkey%5D=123"
    }
    env = ::Rack::MockRequest.env_for(uri, opts)
    request = ::Rack::Request.new(env)
    request.POST["var"].should == {"key" => "123"}

    request_proxy = ::OAuth::RequestProxy.proxy(request)
    (request_proxy.send :request_params)["_method"].should == "put"
    (request_proxy.send :request_params)["var[key]"].should == "123"
  end
end
