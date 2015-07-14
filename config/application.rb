require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DinnerDash
  class Application < Rails::Application
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.mandrillapp.com',
      port:                 '587',
      domain:               'supper-sprint.herokuapp.com',
      user_name:            ENV["EMAIL"],
      password:             ENV["PASSWORD"],
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end
end
