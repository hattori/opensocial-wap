require 'oauth/request_proxy/rack_request'

module OpensocialWap::OAuth::RequestProxy
  class OAuthRackRequestProxy < OAuth::RequestProxy::RackRequest
    
    def normalized_parameters
      normalize(my_parameters_for_signature)
    end
    
    def my_parameters_for_signature
      my_parameters.reject { |k,v| k == "oauth_signature" || unsigned_parameters.include?(k)}
    end
    
    def my_parameters
      merged_params = merge query_params_hash, request_params_hash
      merged_params = merge merged_params, header_params
    end
    
    private
    
    def query_params_hash
      parse_params request.query_string
    end
    
    
    def request_params_hash
      post = request.POST
      parse_params request.env['rack.request.form_vars']
    end
    
    # request.POST は env["rack.request.form_hash"] の値を返すが、POSTデータ中に
    # "..var%5Bkey%5D=123.." のような部分があると、"var"=>{"key"=>"123"} という
    # 形式に変換してしまう.
    # これを、"var[key]"=>"123" を返すように修正する.
    def parse_params params_str
      if params_str && params_str.size > 0
        params_str.split('&').inject({}) do |hsh, i|
          kv = i.split('=')
          key = ::Rack::Utils::unescape(kv[0])
          if hsh[key]
            hsh[key] << kv[1] ? ::Rack::Utils::unescape(kv[1]) : ''
          else
            hsh[key] = [kv[1] ? ::Rack::Utils::unescape(kv[1]) : '']
          end
          hsh
        end
      else
        {}
      end
    end
    
    def merge hash1, hash2
      result = hash1.dup
      hash2.each do |k,v|
        v = [v] unless v.is_a? Array
        if result[k]
          result[k] += v
        else
          result[k] = v
        end
      end
      result
    end
    
  end
end