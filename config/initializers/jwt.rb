# JSON web token related configurations

Rails.application.config.jwt_key = ENV['JWT_KEY'] || 'super_secret_string'
