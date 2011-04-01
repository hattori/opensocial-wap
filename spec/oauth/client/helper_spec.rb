# -*- coding: utf-8 -*-
require 'spec_helper'

describe ::OpensocialWap::OAuth::Client::Helper do
  it 'oauth_parameters に、xoauth_requestor_id が含まれること' do
    options = {
      :consumer => ::OAuth::Consumer.new('key', 'secret'),
      :xoauth_requestor_id => '123456',
    }
    helper = ::OAuth::Client::Helper.new(nil, options)
    helper.oauth_parameters.keys.should include "xoauth_requestor_id"
    helper.oauth_parameters['xoauth_requestor_id'].should == '123456'
  end
end
