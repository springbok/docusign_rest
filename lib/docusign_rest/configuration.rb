module DocusignRest
  module Configuration
    VALID_CONNECTION_KEYS  = [:endpoint, :api_version, :user_agent, :method].freeze
    VALID_OPTIONS_KEYS     = [:access_token, :username, :password, :integrator_key,
                              :account_id, :format, :ca_file, :session, :user_id,
                              :auth_method, :oauth_base_url, :oauth_scopes, :rsa_key_file, :default_user_id].freeze
    VALID_CONFIG_KEYS      = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS

    DEFAULT_ENDPOINT       = 'https://demo.docusign.net/restapi'
    DEFAULT_API_VERSION    = 'v2'
    DEFAULT_USER_AGENT     = "DocusignRest API Ruby Gem #{DocusignRest::VERSION}".freeze
    DEFAULT_METHOD         = :get

    DEFAULT_ACCESS_TOKEN   = nil
    DEFAULT_SESSION        = nil

    DEFAULT_USER_ID        = nil
    DEFAULT_DEFAULT_USER_ID= nil
    DEFAULT_USERNAME       = nil
    DEFAULT_PASSWORD       = nil
    DEFAULT_INTEGRATOR_KEY = nil
    DEFAULT_ACCOUNT_ID     = nil
    DEFAULT_CA_FILE        = nil # often found at: '/etc/ssl/certs/cert.pem'
    DEFAULT_RSA_KEY_FILE   = nil
    DEFAULT_FORMAT         = :json

    DEFAULT_AUTH_METHOD    = :oauth # other options :password, :token

    DEFAULT_OAUTH_BASE_URL = 'account-d.docusign.com'
    DEFAULT_OAUTH_SCOPES   = 'signature impersonation'

    # Build accessor methods for every config options so we can do this, for example:
    #   DocusignRest.format = :xml
    attr_accessor *VALID_CONFIG_KEYS

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    def reset
      self.endpoint       = DEFAULT_ENDPOINT
      self.api_version    = DEFAULT_API_VERSION
      self.user_agent     = DEFAULT_USER_AGENT
      self.method         = DEFAULT_METHOD
      self.access_token   = DEFAULT_ACCESS_TOKEN
      self.username       = DEFAULT_USERNAME
      self.password       = DEFAULT_PASSWORD
      self.integrator_key = DEFAULT_INTEGRATOR_KEY
      self.account_id     = DEFAULT_ACCOUNT_ID
      self.format         = DEFAULT_FORMAT
      self.ca_file        = DEFAULT_CA_FILE
      self.oauth_base_url = DEFAULT_OAUTH_BASE_URL
      self.user_id        = DEFAULT_USER_ID
      self.oauth_scopes   = DEFAULT_OAUTH_SCOPES
      self.session        = DEFAULT_SESSION
      self.auth_method    = DEFAULT_AUTH_METHOD
      self.rsa_key_file   = DEFAULT_RSA_KEY_FILE
      self.default_user_id= DEFAULT_DEFAULT_USER_ID
    end

    # Allow configuration via a block
    def configure
      yield self
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end
  end
end
