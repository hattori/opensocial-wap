# -*- coding: utf-8 -*-

# Opensocial WAP テスト用コントローラ.
# url_format は :query
class OpensocialWapQueryController < ApplicationController
  opensocial_wap :url_format => :query, :public_path_format => :query
  
  def index
  end
end
