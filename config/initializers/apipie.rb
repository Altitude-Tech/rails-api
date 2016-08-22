Apipie.configure do |config|
  config.app_name                = 'Sensly Api'
  config.api_base_url            = '/v1'
  config.doc_base_url            = '/help'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
