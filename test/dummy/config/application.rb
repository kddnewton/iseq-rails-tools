require_relative 'boot'

require 'action_controller/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require 'iseq_rails_tools'

module Dummy
  class Application < Rails::Application
  end
end
