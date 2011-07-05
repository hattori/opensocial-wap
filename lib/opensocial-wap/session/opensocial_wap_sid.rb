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
          #
          # なお、jpmobile と併用する場合、jpmobile 関係の middleware が実行されるまでは、
          # request.params メソッドを使用しないこと(文字コード変換で問題が発生するため).
          def extract_session_id(env)
            stale_session_check! do
              request = ::Rack::Request.new(env)
              if use_opensocial_wap_sid?(request)
                # opensocial_(viewer|owner)_id をsession_idとして使用.
                sid = opensocial_user_id(request)
              else
                # 通常の方法でsession_idを取得.
                sid = request.cookies[@key]
                sid ||= request.GET[@key] unless @cookie_only
              end
#puts "##### sid : #{sid} ###"
              sid
            end
          end

          # セッションIDを、opensocial_(viewer|owner)_id にするかどうかを判定する.
          # 以下の条件を満たしたときに、true を返す.
          # * アプリの初期化時に、config.opensocial_wap[:session_id] = :parameter が指定されている.
          # * OAuthの検証にパスしている.
          # * opensocial_(viewer|owner)_id がクエリパラメータに存在する.
          # 以上の条件を満たさない場合は、通常通り cookie からセッションIDを取得する.
          def use_opensocial_wap_sid?(request)
            app_config = Rails.application.config
            if app_config.respond_to? :opensocial_wap
              sid = app_config.opensocial_wap[:session_id] || :cookie # デフォルトでは無効(cookieからセッションIDを取得する).
              if sid.to_sym == :parameter
                # OAuthの検証にパスしている.
                if request.env['opensocial-wap.oauth-verified']
                  # opensocial_(viewer|owner)_id がクエリパラメータに存在する.
                  if opensocial_user_id(request)
                    return true
                  end
                end
              end
            end
            false
          end

          def opensocial_user_id(request)
            unless @opensocial_user_id
              params = begin
                         request.GET.merge(request.POST)
                       rescue EOFError => e
                         request.GET
                       end
              @opensocial_user_id = params['opensocial_viewer_id'] || params['opensocial_owner_id']
            end
            @opensocial_user_id
          end
        end
      end    
    end
  end
end

class ActionDispatch::Session::AbstractStore
  include ::OpensocialWap::Session::OpensocialWapSid
end
