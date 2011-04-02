# -*- coding: utf-8 -*-
require 'spec_helper'

require 'opensocial-wap/oauth/request_proxy/exclude_post_params_from_signature'

describe OpensocialWap::OAuth::RequestProxy::ExcludePostParamsFromSignature do

  it "parameters_for_signatureにPOSTパラメータが含まれないこと" do
    uri = 'http://example.com/?opensocial_app_id=877&opensocial_owner_id=23&sample_key=sample_value'
    opts = {
      :method => "POST",
      :params => "a=b&c=d",
      :input => "_method=put&var%5Bkey%5D=123"
    }
    env = ::Rack::MockRequest.env_for(uri, opts)
    request = ::Rack::Request.new(env)

    request_proxy = ::OAuth::RequestProxy.proxy(request)
    request_proxy.parameters_for_signature.keys.should include "opensocial_app_id"
    request_proxy.parameters_for_signature.keys.should include "opensocial_owner_id"
    request_proxy.parameters_for_signature.keys.should include "sample_key"
    request_proxy.parameters_for_signature.keys.should_not include "_method"
    request_proxy.parameters_for_signature.keys.should_not include "_var[key]"
  end
end
