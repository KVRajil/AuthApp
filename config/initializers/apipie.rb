Apipie.configure do |config|
  config.app_name                = 'auth-app'
  config.api_base_url            = '/'
  config.doc_base_url            = '/apipie'
  config.api_controllers_matcher = Rails.root.join('app/controllers/**/*.rb').to_s
end
