require 'oauth/request_proxy/rack_request'

module OpensocialWap
  module OAuth
    module RequestProxy
      class BasicRackRequest < ::OAuth::RequestProxy::RackRequest

        private
        
        def request_params
          request.POST
          form_params = request.env['rack.request.form_vars']
          if form_params && form_params.size > 0
            form_params.split('&').inject({}) do |hsh, i| 
              kv = i.split('=')
              hsh[CGI::unescape(kv[0])] = kv[1] ? CGI::unescape(kv[1]) : ''
              hsh 
            end
          else      
            {}
          end
        end
      end
    end
  end
end
