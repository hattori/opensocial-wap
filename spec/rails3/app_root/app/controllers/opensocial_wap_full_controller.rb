# -*- coding: utf-8 -*-

# Opensocial WAP テスト用コントローラ.
# url_format は :full
class OpensocialWapFullController < ApplicationController
  opensocial_wap :url_format => :full
  
  def index
  end
end
