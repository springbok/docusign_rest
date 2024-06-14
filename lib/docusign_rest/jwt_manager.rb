require 'jwt'
class JwtManager

  # Request JWT User Token
  # @param [String] client_id DocuSign OAuth Client Id(AKA Integrator Key)
  # @param [String] user_id DocuSign user Id to be impersonated
  # @param [String] private_key_or_filename the RSA private key
  # @param [Number] expires_in number of seconds remaining before the JWT assertion is considered as invalid
  # @param scopes The list of requested scopes.  Client applications may be scoped to a limited set of system access.
  # @return [OAuth::OAuthToken]
  def request_jwt_user_token(client_id, user_id, private_key_or_filename, scopes, expires_in = 3600)
    raise ArgumentError.new('client_id cannot be empty')  if client_id.empty?
    raise ArgumentError.new('user_id cannot be empty')  if user_id.empty?
    raise ArgumentError.new('private_key_or_filename cannot be empty')  if private_key_or_filename.empty?

    scopes = scopes.join(' ') if scopes.kind_of?(Array)
    expires_in = 3600 if expires_in > 3600
    now = Time.now.to_i
    claim = {
      "iss" => client_id,
      "sub" => user_id,
      "aud" => self.get_oauth_base_path,
      "iat" => now,
      "exp" => now + expires_in,
      "scope"=> scopes
    }

    private_key = if private_key_or_filename.include?("-----BEGIN RSA PRIVATE KEY-----")
                    private_key_or_filename
                  else
                    File.read(private_key_or_filename)
                  end

    private_key_bytes = OpenSSL::PKey::RSA.new private_key
    token = JWT.encode claim, private_key_bytes, 'RS256'
    params = {
        :header_params => {"Content-Type" => "application/x-www-form-urlencoded"},
        :form_params => {
            "assertion" => token,
            "grant_type" => OAuth::GRANT_TYPE_JWT
        },
        :return_type => 'OAuth::OAuthToken',
        :oauth => true
    }
    data, status_code, headers = self.call_api("POST", "/oauth/token", params)


    raise ApiError.new('Some error accrued during process') if data.nil?

    self.set_default_header('Authorization', data.token_type + ' ' + data.access_token)
    data
  end

end