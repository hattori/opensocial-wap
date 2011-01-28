# -*- coding: utf-8 -*-

module OpensocialWap
  module Session
    module OpensocialWapSid
      
      def self.included(base)
        base.class_eval do
          # クエリに含まれる opensocial_viewer_id (もしなければ opensocial_owner_id) を
          # セッションのキーにする.
          # cookie は使用しないので、session store で CookieStore を指定しないこと.
          #
          # session store の指定で行った設定が反映されるかどうかは、session store の実装次第. 
          # たとえば、:expire_after の設定は、:mem_cache_store では反映されるが、他の session 
          # store でも反映されるとは限らない.
          def extract_session_id(env)
            stale_session_check! do
              request = ActionDispatch::Request.new(env)
              if use_opensocial_wap_sid? 
                # opensocial_(viewer|owner)_id をsession_idとして使用.
                get_params = request.query_parameters
                session_key = get_params.key?('opensocial_viewer_id') ? 'opensocial_viewer_id' : 'opensocial_owner_id'
                sid = get_params[session_key]
              else
                # 通常の方法でsession_idを取得.
                sid = request.cookies[@key]
                sid ||= request.params[@key] unless @cookie_only
              end
 puts "##### sid : #{sid} #####"
              sid
            end
          end

          def use_opensocial_wap_sid?
            # TODO
            # initializer で、opensocial_wap_sid を使うよう指定している.
            # OAuth の検証にパスしていて, opensocial_(viewer|owner)_id がクエリパラメータに存在する.
            true
          end
        end
      end    
    end
  end
end

module ActionDispatch
  module Session
    class AbstractStore
      include ::OpensocialWap::Session::OpensocialWapSid
    end
  end
end


