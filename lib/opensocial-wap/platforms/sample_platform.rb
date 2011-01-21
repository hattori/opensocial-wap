module OpensocialWap
  class SamplePlatform < OpensocialPlatform
    def signature_base_string method, normalized_uri, parameters_for_signature, get_params, post_params
      # remove POST parameters from parameters_for_signature
      normalized_params = normalize(parameters_for_signature.reject{ |k,v| post_params.has_key?(k)})
      base = [method, normalized_uri, normalized_params]
      base.map { |v| escape(v) }.join("&")
    end
  end
end
