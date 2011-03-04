# -*- coding: utf-8 -*-

# Opensocial WAP テスト用コントローラ.
# url_format は :plain
class OpensocialWapPlainController < ApplicationController
  opensocial_wap :url_format => :plain, :public_path_format => :plain
  
  def index
  end
end
