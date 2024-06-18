
require_relative '../lib/docusign_rest'

DocusignRest.configure do |config|
  config.integrator_key = "ab5889f2-5723-4769-9dab-3fe9eb810325"
  config.account_id     = "964296e1-b2c7-4477-a6d3-f11a81494243"
  config.endpoint       = "https://demo.docusign.net/restapi"
  config.user_id        = "045a5dc8-b170-40c7-ab0c-cd261280fdea"
  config.oauth_base_url = "account-d.docusign.com"
  config.auth_method    = :oauth
  config.rsa_key_file   = File.join(Dir.pwd, 'test', 'docusign_private_key.txt')
  config.api_version    = 'v2.1'
end

session = {ds_access_token: nil}
api = DocusignRest::Client.new(session: session)
api.request_jwt_user_token
api.get_login_information