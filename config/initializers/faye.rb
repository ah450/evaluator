# Faye configurations
Rails.application.config.middleware.delete Rack::Lock
Rails.application.config.middleware.use FayeRails::Middleware, mount: '/faye', timeout: 25 do
    map default: :block
end