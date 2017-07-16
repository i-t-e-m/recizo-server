require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RecizoServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/models/youkeisai"]
    config.autoload_paths += Dir["#{config.root}/app/models/kasai"]
    config.autoload_paths += Dir["#{config.root}/app/models/konsai"]
    config.autoload_paths += Dir["#{config.root}/app/models/imo"]
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]

  end
end
