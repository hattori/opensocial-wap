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
              if use_opensocial_wap_sid?(request)
                # opensocial_(viewer|owner)_id をsession_idとして使用.
                params = params_for_sid(request)
                session_key = params.key?('opensocial_viewer_id') ? 'opensocial_viewer_id' : 'opensocial_owner_id'
                sid = params[session_key]
              else
                # 通常の方法でsession_idを取得.
                sid = request.cookies[@key]
                sid ||= request.params[@key] unless @cookie_only
              end
#puts "##### sid : #{sid} ###"
              sid
            end
          end

          # セッションIDを、opensocial_(viewer|owner)_id にするかどうかを判定する.
          # 以下の条件を満たしたときに、true を返す.
          # * アプリの初期化時に、config.opensocial_wap.sid = :parameter が指定されている.
          # * OAuthの検証にパスしている.
          # * opensocial_(viewer|owner)_id がクエリパラメータに存在する.
          # 以上の条件を満たさない場合は、通常通り cookie からセッションIDを取得する.
          def use_opensocial_wap_sid?(request)
            app_config = Rails.application.config
            if app_config.respond_to? :opensocial_wap
              sid = app_config.opensocial_wap.sid || :cookie # デフォルトでは無効(cookieからセッションIDを取得する).
              if sid.to_sym == :parameter
                # OAuthの検証にパスしている.
                if request.opensocial_oauth_verified?
                  # opensocial_(viewer|owner)_id がクエリパラメータに存在する.
                  params = params_for_sid(request)
                  if [ 'opensocial_viewer_id',  'opensocial_owner_id'].any? {|p| params.keys.include? p }
                    return true
                  end
                end
              end
            end
            false
          end

          def params_for_sid(request)
            @params_for_sid ||= request.query_parameters.merge(request.request_parameters)
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
